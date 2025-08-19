# Kubernetes & Istio Deployment

This folder contains all the required manifests for deploying **Kubernetes** and **Istio** resources, along with two scripts that automate their **setup** and **deletion** from one of the master nodes in the clusters.

## ⚙️ Features

- Deployment manifests for Kubernetes services
- Deployment manifests for Istio services
- Automation scripts:
  - `set-up-fullArch.sh` → Automates the deployment
  - `del-fullArch.sh` → Automates the deletion

## 🔑 Important Notes

For enabling **inter-master communication** and **inter-control-plane access**, it is necessary to:

1. Ensure that the required **OpenStack connections** are in place.
2. Define the **Kubernetes context** correctly.

An extensive guide on configuring access for multiple clusters can be found here:  
[Kubernetes: Configure access to multiple clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters)

