#!/bin/bash

set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <cluster_name> <service_name> <patch>"
  exit 1
fi

#cluster -> service -> patching type

CLUSTER_NAME="$1"
PATCHED_SVC="$2"
PATCH="$3"
INFO_FILE="instances-info.json"

if [[ "$CLUSTER_NAME" == "edge-cluster" ]]; then
  CLUSTER_MASTER="master-edge"
  REMOTE_CLUSTER="cloud-cluster"
elif [[ "$CLUSTER_NAME" == "cloud-cluster" ]]; then
  CLUSTER_MASTER="master-cloud"
  REMOTE_CLUSTER="edge-cluster"
else
  echo "❌ Invalid source cluster: $CLUSTER_NAME"
  exit 1
fi

get_ip_from_instance() {
  local name="$1"
  jq -r --arg name "$name" '.[] | select(.name==$name) | .ports[0].fixed_ip' "$INFO_FILE"
}

MASTER_IP=$(get_ip_from_instance "$CLUSTER_MASTER")

echo "$CLUSTER_MASTER has the $MASTER_IP"

if [[ "$PATCH" == "local" ]]; then
  ssh -i keyshare -o LogLevel=ERROR ubuntu@"$MASTER_IP" <<EOF
  KUBECONFIG=/etc/kubernetes/admin.conf kubectl patch virtualservice "$PATCHED_SVC" -n car --type=merge -p '{
    "spec": {
      "http": [
        {
          "route": [
            {
              "destination": {
                "host": "$PATCHED_SVC.car.svc.cluster.local",
                "subset": "${CLUSTER_NAME}"
              },
              "weight": 100
            }
          ]
        }
      ]
    }
  }'
EOF
echo "$PATCHED_SVC is being accessed from the $CLUSTER_NAME"


elif [[ "$PATCH" == "remote" ]]; then
  ssh -i keyshare -o LogLevel=ERROR ubuntu@"$MASTER_IP" <<EOF > /dev/null 2>&1
  KUBECONFIG=/etc/kubernetes/admin.conf kubectl patch virtualservice "$PATCHED_SVC" -n car --type=merge -p '{
    "spec": {
      "http": [
        {
          "route": [
            {
              "destination": {
                "host": "$PATCHED_SVC.car.svc.cluster.local",
                "subset": "${REMOTE_CLUSTER}"
              },
              "weight": 100
            }
          ]
        }
      ]
    }
  }'
EOF
echo "$PATCHED_SVC is being accessed from the $REMOTE_CLUSTER"

elif [[ "$PATCH" == "split" ]]; then
  ssh -i keyshare -o LogLevel=ERROR ubuntu@"$MASTER_IP" <<EOF > /dev/null 2>&1
  KUBECONFIG=/etc/kubernetes/admin.conf kubectl patch virtualservice "$PATCHED_SVC" -n car --type=merge -p '{
    "spec": {
    "http": [
      {
        "route": [
          {
            "destination": {
              "host": "$PATCHED_SVC.car.svc.cluster.local",
              "subset": "edge-cluster"
            },
            "weight": 50
          },
          {
            "destination": {
              "host": "$PATCHED_SVC.car.svc.cluster.local",
              "subset": "cloud-cluster"
            },
            "weight": 50
          }
        ]
      }
    ]
  }
  }'
EOF
echo "$PATCHED_SVC is being accessed from the $CLUSTER_NAME and $REMOTE_CLUSTER"

fi
