#!/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <instance_name>"
  exit 1
fi

INSTANCE_NAME="$1"
CLUSTER=${CLUSTER_NAME:-}
#CLOUD="openstack"
INFO_FILE="instances-info.json"


if [[ "$CLUSTER" == "edge-cluster" ]]; then
  MASTER_NODE="master-edge"
elif [[ "$CLUSTER" == "cloud-cluster" ]]; then
  MASTER_NODE="master-cloud"
else
  echo "??? Invalid source cluster: $CLUSTER"
  exit 1
fi


# Get instance info from JSON
get_floating_ip_from_instance() {
  local name="$1"
  jq -r --arg name "$name" '.[] | select(.name==$name) | .ports[0].floating_ips[0]' "$INFO_FILE"
}

get_network_from_instance() {
  local name="$1"
  jq -r --arg name "$name" '.[] | select(.name==$name) | .ports[0].network' "$INFO_FILE"
}


MASTER_NODE_FLOATING_IP=$(get_floating_ip_from_instance "$MASTER_NODE")
USER_NET=$(get_network_from_instance "$MASTER_NODE")
PORT_NAME="${INSTANCE_NAME}-${USER_NET}-port"

#create port and assign to vm including floating ip

echo "Creating openstack instance for $INSTANCE_NAME in the $CLUSTER openstack cluster"
openstack port create --network "$USER_NET" --security-group kubernetes --fixed-ip subnet=$(openstack subnet list --network "$USER_NET" -f value -c ID) "$PORT_NAME" > /dev/null 2>&1
FLOATING_IP_INSTANCE=$(openstack floating ip create public -f value -c floating_ip_address)
PORT_ID=$(openstack port show "$PORT_NAME" -f value -c id)
openstack server create --image user-snapshot --flavor m1.small --key-name sharedkey --config-drive true --nic port-id="$PORT_ID" "$INSTANCE_NAME" > /dev/null 2>&1
openstack floating ip set --port "$PORT_ID" "$FLOATING_IP_INSTANCE" > /dev/null 2>&1
FIXED_IP_INSTANCE=$(openstack port show "$PORT_ID" -f json | jq -r '.fixed_ips[0].ip_address')
sleep 30
echo "New user fixed ip: $FIXED_IP_INSTANCE and  floating ip: $FLOATING_IP_INSTANCE"


echo "Configurating openstack instance for $INSTANCE_NAME"
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$FLOATING_IP_INSTANCE" "echo '127.0.0.1 $INSTANCE_NAME' | sudo tee -a /etc/hosts > /dev/null"
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$FLOATING_IP_INSTANCE" "echo 'nameserver 8.8.8.8' | sudo tee /etc/resolv.conf > /dev/null"
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$FLOATING_IP_INSTANCE" 'echo "network:
  version: 2
  ethernets:
    en:
      match:
        name: \"en*\"
      dhcp4: true
      dhcp6: false
      optional: true" | sudo tee /etc/netplan/50-cloud-init.yaml > /dev/null'
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$FLOATING_IP_INSTANCE" "sudo netplan apply"

echo "Joining $INSTANCE_NAME to the $CLUSTER kubernetes cluster"
JOIN_CMD=$(ssh -i keyshare -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@"$MASTER_NODE_FLOATING_IP" 'sudo kubeadm token create --print-join-command') > /dev/null 2>&1
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$FLOATING_IP_INSTANCE" "sudo $JOIN_CMD" > /dev/null 2>&1
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_NODE_FLOATING_IP" "KUBECONFIG=/etc/kubernetes/admin.conf kubectl label node $INSTANCE_NAME user-allocating=$INSTANCE_NAME" > /dev/null 2>&1

# update the instances information file
TMP_FILE=$(mktemp)

jq --arg name "$INSTANCE_NAME" \
   --arg port_id "$PORT_ID" \
   --arg net "$USER_NET" \
   --arg fixed_ip "$FIXED_IP_INSTANCE" \
   --arg ip "$FLOATING_IP_INSTANCE" \
   '.[. | length] = {
      name: $name,
      ports: [
        {
          port_id: $port_id,
          network: $net,
	  fixed_ip: $fixed_ip,
          floating_ips: [$ip]
        }
      ]
    }' "$INFO_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$INFO_FILE"

echo "??? $INFO_FILE updated with the info from $INSTANCE_NAME"
