#!/bin/bash

#create namespaces on both clusters
kubectl create namespace car --context=edge-cluster
kubectl create namespace car --context=cloud-cluster

kubectl create namespace user --context=edge-cluster
kubectl create namespace user --context=cloud-cluster

kubectl create namespace orchestrator --context=edge-cluster
kubectl create namespace orchestrator --context=cloud-cluster

#label namespaces to enable istio-injection
kubectl label namespace car istio-injection=enabled --context=edge-cluster
kubectl label namespace car istio-injection=enabled --context=cloud-cluster

#apply the proxy service on both clusters
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/proxy-service.yaml -n car --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/proxy-service.yaml -n car --context=cloud-cluster

#apply the edge service on both clusters
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/edge-service-versioned.yaml -n car -l service=edge-service --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/edge-service-versioned.yaml -n car -l service=edge-service --context=cloud-cluster

#deploy the edge service on both clusters labeling them
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/edge-service-versioned.yaml -n car -l cluster=edge-cluster --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/edge-service-versioned.yaml -n car -l cluster=cloud-cluster --context=cloud-cluster

#apply the cloud service on both clusters
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/cloud-service-versioned.yaml -n car -l service=cloud-service --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/cloud-service-versioned.yaml -n car -l service=cloud-service --context=cloud-cluster

#apply the cloud service deployment on both clusters by labeling them
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/cloud-service-versioned.yaml -n car -l cluster=edge-cluster --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/cloud-service-versioned.yaml -n car -l cluster=cloud-cluster --context=cloud-cluster

#deploy the redis service on both clusters
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/redis-service.yaml -n car -l cluster=edge-cluster --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/redis-service.yaml -n car -l cluster=cloud-cluster --context=cloud-cluster

kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/redis-publisher-deployment.yaml -n car -l cluster=edge-cluster --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/redis-publisher-deployment.yaml -n car -l cluster=cloud-cluster --context=cloud-cluster

#deploy the users GWs service on both clusters
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/tracker-gateway-service.yaml -n user --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/tracker-gateway-service.yaml -n user --context=cloud-cluster

#deploy the clusters orchestrator
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/orchestrator.yaml -n orchestrator -l cluster=edge-cluster --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/manifests/orchestrator.yaml -n orchestrator -l cluster=cloud-cluster --context=cloud-cluster


#apply the destination rules and virtual services on both clusters for the edge service
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/edge-service-conf/dr-edge-service.yaml -n car --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/edge-service-conf/dr-edge-service.yaml -n car --context=cloud-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/edge-service-conf/vs-edge-service-edge-cluster.yaml -n car --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/edge-service-conf/vs-edge-service-cloud-cluster.yaml -n car --context=cloud-cluster

#apply the destination rules and virtual services on both clusters for the cloud service
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/cloud-service-conf/dr-cloud-service.yaml -n car --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/cloud-service-conf/dr-cloud-service.yaml -n car --context=cloud-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/cloud-service-conf/vs-cloud-service.yaml -n car --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/cloud-service-conf/vs-cloud-service.yaml -n car --context=cloud-cluster

#apply the destination rules and virtual services on both clusters for the redis service
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/redis-service-conf/dr-redis-service.yaml -n car --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/redis-service-conf/vs-redis-service.yaml -n car --context=edge-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/redis-service-conf/dr-redis-service.yaml -n car --context=cloud-cluster
kubectl apply -f /home/ubuntu/car-service/full-arch/test-confs/redis-service-conf/vs-redis-service.yaml -n car --context=cloud-cluster
