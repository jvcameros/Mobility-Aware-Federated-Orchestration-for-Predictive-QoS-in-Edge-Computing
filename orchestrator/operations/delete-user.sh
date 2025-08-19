#!/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <instance_name>"
  exit 1
fi

INSTANCE_NAME="$1"
INFO_FILE="instances-info.json"


get_network_from_instance() {
  local name="$1"
  jq -r --arg name "$name" '.[] | select(.name==$name) | .ports[0].network' "$INFO_FILE"
}

get_floating_ip_from_instance() {
  local name="$1"
  jq -r --arg name "$name" '.[] | select(.name==$name) | .ports[0].floating_ips[0]' "$INFO_FILE"
}

USER_NET=$(get_network_from_instance "$INSTANCE_NAME")
PORT_NAME="${INSTANCE_NAME}-${USER_NET}-port"


if [[ "$USER_NET" == "edge_net" ]]; then
  MASTER_NODE="master-edge"
elif [[ "$USER_NET" == "cloud_net" ]]; then
  MASTER_NODE="master-cloud"
fi

USER_FLOATING_IP=$(get_floating_ip_from_instance "$INSTANCE_NAME")
MASTER_FLOATING_IP=$(get_floating_ip_from_instance "$MASTER_NODE")

echo "Deleting node from the kubernetes control plane"
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR  ubuntu@"$MASTER_FLOATING_IP" "KUBECONFIG=/etc/kubernetes/admin.conf kubectl drain $INSTANCE_NAME --ignore-daemonsets --delete-emptydir-data"
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR  ubuntu@"$MASTER_FLOATING_IP" "KUBECONFIG=/etc/kubernetes/admin.conf kubectl delete node $INSTANCE_NAME"


echo "Deleting node from the openstack control plane"
openstack server delete "$INSTANCE_NAME"
openstack port delete "$PORT_NAME"
openstack floating ip delete "$USER_FLOATING_IP"


echo "Removing $INSTANCE_NAME from $INFO_FILE"
TMP_FILE=$(mktemp)

jq --arg name "$INSTANCE_NAME" 'del(.[]
  | select(.name == $name))' "$INFO_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$INFO_FILE"

echo "✅ $INSTANCE_NAME removed from $INFO_FILE"
