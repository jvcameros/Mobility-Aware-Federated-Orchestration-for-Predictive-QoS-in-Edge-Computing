#!/bin/bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <instance_name> <destination_cluster>"
  exit 1
fi

SOURCE_CLUSTER=${CLUSTER_NAME:-}
INSTANCE_NAME="$1"
DEST_CLUSTER="$2"

USERS_INFO_FILE="/app/instances-info.json"
PRED_NET="10.0.150.0/24"

USER_SEQ_FILE="/app/user_sequences.json"
REMOTE_USER_SEQ_FILE="/app/user_sequences.json"

if [[ "$SOURCE_CLUSTER" == "edge-cluster" ]]; then
  SOURCE_MASTER="master-edge"
  DEST_MASTER="master-cloud"
elif [[ "$SOURCE_CLUSTER" == "cloud-cluster" ]]; then
  SOURCE_MASTER="master-cloud"
  DEST_MASTER="master-edge"
else
  echo "Invalid source cluster: $SOURCE_CLUSTER" >&2
  exit 1
fi

if [[ "$DEST_CLUSTER" == "edge-cluster" ]]; then
  ACCESS_GW="10.0.100.20"
  REMOTE_NET="10.0.10.0/24"
  DEST_ORCH="orchestrator_edge"
elif [[ "$DEST_CLUSTER" == "cloud-cluster" ]]; then
  ACCESS_GW="10.0.10.20"
  REMOTE_NET="10.0.100.0/24"
  DEST_ORCH="orchestrator_cloud"
else
  echo "Invalid destination cluster: $DEST_CLUSTER" >&2
  exit 1
fi

get_field() {
  local name="$1"
  local field="$2"
  jq -r ".[] | select(.name==\"$name\") | $field" "$USERS_INFO_FILE"
}

MASTER_SOURCE_IP=$(get_field "$SOURCE_MASTER" ".ports[0].fixed_ip")
MASTER_DEST_IP=$(get_field "$DEST_MASTER" ".ports[0].fixed_ip")
INSTANCE_IP=$(get_field "$INSTANCE_NAME" ".ports[0].fixed_ip")
FLOATING_IP=$(get_field "$INSTANCE_NAME" ".ports[0].floating_ips[0]")
PORT_ID=$(get_field "$INSTANCE_NAME" ".ports[0].port_id")
INSTANCE_NET=$(get_field "$INSTANCE_NAME" ".ports[0].network")
DEST_MASTER_NET=$(get_field "$DEST_MASTER" ".ports[0].network")
DEST_ORCH_IP=$(get_field "$DEST_ORCH" ".ports[0].fixed_ip")

echo "Draining and deleting $INSTANCE_NAME from $SOURCE_CLUSTER"
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_SOURCE_IP" \
  "KUBECONFIG=/etc/kubernetes/admin.conf kubectl drain $INSTANCE_NAME --ignore-daemonsets --delete-emptydir-data"
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_SOURCE_IP" \
  "KUBECONFIG=/etc/kubernetes/admin.conf kubectl delete node $INSTANCE_NAME"

echo "Resetting node $INSTANCE_NAME"
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$INSTANCE_IP" \
  "sudo hostnamectl set-hostname $INSTANCE_NAME && \
   sudo kubeadm reset --force && \
   sudo ipvsadm --clear && \
   sudo rm -rf /etc/cni/net.d /var/lib/cni /var/lib/kubelet/* /etc/kubernetes /opt/cni/bin/* && \
   sudo systemctl restart containerd"

echo "Reconfiguring networking on OpenStack"
FIP_ID=$(openstack floating ip list --floating-ip-address "$FLOATING_IP" -f value -c ID)
openstack floating ip unset "$FIP_ID"
openstack server remove port "$INSTANCE_NAME" "$PORT_ID"
openstack port delete "$PORT_ID"
NEW_PORT_ID=$(openstack port create --network "$DEST_MASTER_NET" "${INSTANCE_NAME}-${DEST_MASTER_NET}-port" -f value -c id)
openstack server add port "$INSTANCE_NAME" "$NEW_PORT_ID"
echo "Reassigning floating IP to new port"
openstack floating ip set --port "$NEW_PORT_ID" "$FIP_ID"
openstack server add security group "$INSTANCE_NAME" kubernetes
NEW_FIXED_IP=$(openstack port show "$NEW_PORT_ID" -f json -c fixed_ips | jq -r '.fixed_ips[0].ip_address')

echo "New fixed IP: $NEW_FIXED_IP"

echo "Updating $USERS_INFO_FILE locally: removing $INSTANCE_NAME"
jq 'map(select(.name!="'$INSTANCE_NAME'"))' "$USERS_INFO_FILE" > tmp.$$.json && mv tmp.$$.json "$USERS_INFO_FILE"

echo "Joining $INSTANCE_NAME to $DEST_CLUSTER"
JOIN_CMD=$(ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_DEST_IP" 'sudo kubeadm token create --print-join-command')
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$FLOATING_IP" \
  "sudo ip route add $REMOTE_NET via $ACCESS_GW &&  \
  sudo ip route add $PRED_NET via $ACCESS_GW && \
  sudo $JOIN_CMD "

ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_DEST_IP" "KUBECONFIG=/etc/kubernetes/admin.conf bash -s" << EOF
  kubectl label node $INSTANCE_NAME istio-cni=enabled
  sleep 5
  kubectl label node $INSTANCE_NAME user-allocating=$INSTANCE_NAME
  kubectl label node $INSTANCE_NAME allocating=car-service
EOF

echo "Updating $USERS_INFO_FILE in $DEST_CLUSTER: adding $INSTANCE_NAME"

ORCH_NS="orchestrator"
ORCH_POD_DEST=$(ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR  ubuntu@"$MASTER_DEST_IP" \
  "KUBECONFIG=/etc/kubernetes/admin.conf kubectl get pod -n $ORCH_NS -o jsonpath='{.items[0].metadata.name}'")

echo "Orchestrator pod ID in destination: $ORCH_POD_DEST"

if [[ -z "$ORCH_POD_DEST" ]]; then
  echo "❌Could not find the orchestrator pod" >&2
  exit 1
fi

echo "🛠️ Generating JSON file for the migrating instance..."
jq -n --arg name "$INSTANCE_NAME" --arg port_id "$NEW_PORT_ID" --arg net "$DEST_MASTER_NET" --arg ip "$NEW_FIXED_IP" --arg fip "$FLOATING_IP" \
  '[{ name: $name, ports: [{ port_id: $port_id, network: $net, fixed_ip: $ip, floating_ips: [$fip] }] }]' > /tmp/new-instance.json

scp -i keyshare  -o StrictHostKeyChecking=no -o LogLevel=ERROR /tmp/new-instance.json ubuntu@"$MASTER_DEST_IP":/tmp/

ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_DEST_IP" "
  KUBECONFIG=/etc/kubernetes/admin.conf kubectl cp /tmp/new-instance.json -n $ORCH_NS $ORCH_POD_DEST:/tmp/new-instance.json
"

ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_DEST_IP" "
  KUBECONFIG=/etc/kubernetes/admin.conf kubectl exec -n $ORCH_NS $ORCH_POD_DEST -- sh -c '
    jq -s \"[.[0][], .[1][]]\" /app/instances-info.json /tmp/new-instance.json > /tmp/tmp.json && \
    mv /tmp/tmp.json /app/instances-info.json
  '
"

