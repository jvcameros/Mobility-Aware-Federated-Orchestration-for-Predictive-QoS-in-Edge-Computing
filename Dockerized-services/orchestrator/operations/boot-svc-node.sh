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


# Primer ssh: aplicar el Deployment
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_SRC_IP" \
  "KUBECONFIG=/etc/kubernetes/admin.conf bash -s" <<EOF
ALLOCATOR=$ALLOCATOR
NAMESPACE=$NAMESPACE
envsubst < <(cat <<EOM
apiVersion: apps/v1
kind: Deployment
metadata:
  name: edge-service-\$ALLOCATOR
spec:
  replicas: 1
  selector:
    matchLabels:
      app: edge-service
      user: \$ALLOCATOR
  template:
    metadata:
      labels:
        app: edge-service
        user: \$ALLOCATOR
    spec:
      nodeSelector:
        user-allocating: \$ALLOCATOR
      containers:
      - name: edge-service
        image: jvcameros/edge-service-user:latest
        ports:
        - containerPort: 8080
        env:
          - name: USER
            value: \$ALLOCATOR
EOM
) | kubectl apply -n \$NAMESPACE -f -
EOF

# Primer ssh: aplicar el Deployment
ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_DEST_IP" \
  "KUBECONFIG=/etc/kubernetes/admin.conf bash -s" <<EOF
ALLOCATOR=$ALLOCATOR
NAMESPACE=$NAMESPACE
envsubst < <(cat <<EOM
apiVersion: apps/v1
kind: Deployment
metadata:
  name: edge-service-\$ALLOCATOR
spec:
  replicas: 1
  selector:
    matchLabels:
      app: edge-service
      user: \$ALLOCATOR
  template:
    metadata:
      labels:
        app: edge-service
        user: \$ALLOCATOR
    spec:
      nodeSelector:
        user-allocating: \$ALLOCATOR
      containers:
      - name: edge-service
        image: jvcameros/edge-service-user:latest
        ports:
        - containerPort: 8080
        env:
          - name: USER
            value: \$ALLOCATOR
EOM
) | kubectl apply -n \$NAMESPACE -f -
EOF

ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_SRC_IP" \
  "KUBECONFIG=/etc/kubernetes/admin.conf bash -s" <<EOF
ALLOCATOR=$ALLOCATOR
NAMESPACE=$NAMESPACE
envsubst < <(cat <<EOM
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: edge-service-\$ALLOCATOR
  namespace: \$NAMESPACE
spec:
  host: edge-service.\$NAMESPACE.svc.cluster.local
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
  subsets:
  - name: \$ALLOCATOR
    labels:
      user: \$ALLOCATOR
EOM
) | kubectl apply -n \$NAMESPACE -f - --context=edge-cluster 
EOF

ssh -i keyshare -o StrictHostKeyChecking=no -o LogLevel=ERROR ubuntu@"$MASTER_DEST_IP" \
  "KUBECONFIG=/etc/kubernetes/admin.conf bash -s" <<EOF
ALLOCATOR=$ALLOCATOR
NAMESPACE=$NAMESPACE
envsubst < <(cat <<EOM
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: edge-service-\$ALLOCATOR
  namespace: \$NAMESPACE
spec:
  host: edge-service.\$NAMESPACE.svc.cluster.local
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
  subsets:
  - name: \$ALLOCATOR
    labels:
      user: \$ALLOCATOR
EOM
) | kubectl apply -n \$NAMESPACE -f - --context=cloud-cluster 
EOF

