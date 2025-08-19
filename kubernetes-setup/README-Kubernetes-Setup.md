This folder includes all the required manifests for the deployment of the Kubernetes and Istio services as well as two scripts that automate its set-up and deletion from one of the master nodes of the clusters.

It's crucial to mark that for setting the inter-master communication and inter-control-plane access, apart from assuring the Openstack required connections, it was needed to define the kubernetes context. An extensive guide on how to do it can be found here: https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters
