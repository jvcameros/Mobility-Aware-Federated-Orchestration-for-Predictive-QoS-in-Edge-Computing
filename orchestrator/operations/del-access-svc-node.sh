#!/bin/bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <pedestrian_node> <car_node>"
  exit 1
fi

ALLOCATOR="$1"
USER="$2"
CLUSTER=${CLUSTER_NAME:-}
INFO_FILE="instances-info.json"
NAMESPACE=car
VS_NAME="edge-service"

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

# Obtains the index of the block to be deleted
HTTP_INDEX=$(ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_IP" \
  "KUBECONFIG=/etc/kubernetes/admin.conf kubectl get virtualservice $VS_NAME -n $NAMESPACE -o json" |
  jq -r --arg USER "$USER" --arg SUBSET "$ALLOCATOR" '
    .spec.http | to_entries[] | 
    select(.value.match[0].headers["x-user-gateway"].exact == $USER and .value.route[0].destination.subset == $SUBSET) | 
    .key'
)

if [[ -z "$HTTP_INDEX" ]]; then
  echo "No matching VirtualService entry found for user=$USER and subset=$ALLOCATOR"
  exit 1
fi

echo "Removing /spec/http/$HTTP_INDEX"

# Enviar el patch para eliminar la entrada
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_SRC_IP" "KUBECONFIG=/etc/kubernetes/admin.conf bash -s" << EOF
kubectl patch virtualservice $VS_NAME -n $NAMESPACE \
--type='json' \
-p='[
  {
    "op": "remove",
    "path": "/spec/http/$HTTP_INDEX"
  }
]'
EOF

ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_DEST_IP" "KUBECONFIG=/etc/kubernetes/admin.conf bash -s" << EOF
kubectl patch virtualservice $VS_NAME -n $NAMESPACE \
--type='json' \
-p='[
  {
    "op": "remove",
    "path": "/spec/http/$HTTP_INDEX"
  }
]'
EOF


