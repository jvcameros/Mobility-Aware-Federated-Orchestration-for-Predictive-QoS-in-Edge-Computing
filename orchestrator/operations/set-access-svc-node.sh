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
  MASTER="master-edge"
  DEST_MASTER="master-cloud"
elif [[ "$CLUSTER" == "cloud-cluster" ]]; then
  MASTER="master-cloud"
else
  echo "Invalid source cluster: $SOURCE_CLUSTER" >&2
  exit 1
fi

MASTER_IP=$(get_field "$MASTER" ".ports[0].fixed_ip")

HTTP_INDEX=$(ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_IP" \
  "KUBECONFIG=/etc/kubernetes/admin.conf kubectl get virtualservice $VS_NAME -n $NAMESPACE -o json" |
  jq '.spec.http | length - 1')

ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_IP" "KUBECONFIG=/etc/kubernetes/admin.conf bash -s" << EOF
kubectl patch virtualservice $VS_NAME -n $NAMESPACE \
--type='json' \
-p='[
  {
    "op": "add",
    "path": "/spec/http/$HTTP_INDEX",
    "value": {
      "match": [
        {
          "headers": {
            "x-user-gateway": {
              "exact": "$USER"
            }
          }
        }
      ],
      "route": [
        {
          "destination": {
            "host": "edge-service.car.svc.cluster.local",
            "subset": "$ALLOCATOR"
          },
          "weight": 100
        }
      ]
    }
  }
]'
EOF

MIGRATION_FILE="/app/svc_migration.json"

if [ ! -f "$MIGRATION_FILE" ]; then
  echo "[]" > "$MIGRATION_FILE"
fi

tmpfile=$(mktemp)

jq --arg uid "$ALLOCATOR" '
  (map(select(.uid == $uid)) | length) as $exists |
  if $exists == 0 then
    . + [{"uid": $uid, "migrations": "1"}]
  else
    map(
      if .uid == $uid then
        .migrations = ( (.migrations | tonumber) + 1 | tostring )
      else
        .
      end
    )
  end
' "$MIGRATION_FILE" > "$tmpfile" && mv "$tmpfile" "$MIGRATION_FILE"

echo "Migration count updated locally for user: $ALLOCATOR"
