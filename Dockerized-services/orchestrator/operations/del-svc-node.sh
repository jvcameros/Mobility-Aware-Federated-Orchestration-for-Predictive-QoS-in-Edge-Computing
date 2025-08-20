#!/bin/bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <pedestrian_node> "
  exit 1
fi

ALLOCATOR="$1"
CLUSTER=${CLUSTER_NAME:-}
INFO_FILE="instances-info.json"
NAMESPACE=car
get_field() {
  local name="$1"
  local field="$2"
  jq -r ".[] | select(.name==\"$name\") | $field" "$INFO_FILE"
}


if [[ "$CLUSTER" == "edge-cluster" ]]; then
  MASTER_SRC="master-edge"
  MASTER_DEST="master-cloud"
elif [[ "$CLUSTER" == "cloud-cluster" ]]; then
  MASTER_SRC="master-cloud"
  MASTER_DEST="master-edge"
else
  echo "Invalid source cluster: $SOURCE_CLUSTER" >&2
  exit 1
fi

MASTER_SRC_IP=$(get_field "$MASTER_SRC" ".ports[0].fixed_ip")
MASTER_DEST_IP=$(get_field "$MASTER_DEST" ".ports[0].fixed_ip")


ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_SRC_IP" "KUBECONFIG=/etc/kubernetes/admin.conf bash -s" << EOF
kubectl delete deployment edge-service-$ALLOCATOR -n car
kubectl delete destinationrule edge-service-$ALLOCATOR -n car

EOF

ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_DEST_IP" "KUBECONFIG=/etc/kubernetes/admin.conf bash -s" << EOF
kubectl delete deployment edge-service-$ALLOCATOR -n car
kubectl delete destinationrule edge-service-$ALLOCATOR -n car


EOF


