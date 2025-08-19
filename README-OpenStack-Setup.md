# OpenStack Scenario Setup

This file explains how the OpenStack scenario was set up for our edge computing environment.

## Network Configuration

For setting up the scenario, we created three OpenStack private networks interconnected through a router. Each of these networks was connected to a public network to allow access to the OpenStack instances. Two of the three networks were used as the PoP (Point of Presence) networks, where the static and mobile edge nodes were attached. Over the third network, the Prediction Service was instantiated.

## Deployment of Edge Nodes

On each of the PoP private networks, we first deployed the static edge nodes, three per cluster, all sharing a private key to ensure security in the environment. One of these nodes acted as the master node for the Kubernetes cluster, while the others functioned as worker nodes. After the Kubernetes cluster composed solely of static nodes was set up, we added the mobile edge nodes. These nodes were booted from private snapshots containing all the required software to ensure optimal performance and proper attachment to their respective Kubernetes clusters.

## Networking Considerations

From a networking perspective, it was critical to configure each instance with access to all other instances in the scenario to enable seamless communication.

## Security Configuration

Regarding security, a generic security group was created for all instances, allowing basic communication capabilities through ICMP, TCP, and protocol-4. This configuration ensured that all nodes could properly communicate and operate within the edge computing environment.

