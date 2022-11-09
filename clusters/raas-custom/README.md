# From Existing Nodes (Custom)

This repo creates a new Kubernetes cluster using RKE in CityCloud.
It creates all infrastructure resources to provision the cluster's master and worker nodes, registering the resources as Rancher **Custom** cluster.

Read more: https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/

## Customization
The `variables.tf` file contains all custom attributes needed to create a custom environment depending on your
requirements.

## Deployment

1. Source the two RC files (`openstack.rc` and `rancher.rc)` under `/.secrets/` to get access to your environments:
    ```
    $ . .secrets/openstack.rc
    $ . .secrets/rancher.rc
    ```

2. Initialize Terraform (for fresh-deployments only)
    ```
    $ terraform init
    ```   
3. Deploy all the infrastructure resources and the Rancher Kubernetes cluster:
    ```
    terraform apply
    ```
   
## Access Kubernetes

1. Export the KUBECONFIG file to get access to the Kubernetes cluster:
    ```
    $ export KUBECONFIG=gen_files/kubeconfig.yml
    ```

2. List all the environment nodes with `kubectl`
    ```
    $ kubectl get nodes -o wide
    NAME            STATUS   ROLES               AGE   VERSION   INTERNAL-IP   EXTERNAL-IP    OS-IMAGE             KERNEL-VERSION     CONTAINER-RUNTIME
    demo-master-1   Ready    controlplane,etcd   9d    v1.18.8   10.1.0.78     31.12.85.116   Ubuntu 20.04.1 LTS   5.4.0-26-generic   docker://19.3.11
    demo-worker-1   Ready    worker              9d    v1.18.8   10.1.0.254    89.46.80.117   Ubuntu 20.04.1 LTS   5.4.0-48-generic   docker://19.3.11
    demo-worker-2   Ready    worker              9d    v1.18.8   10.1.0.99     31.12.85.190   Ubuntu 20.04.1 LTS   5.4.0-48-generic   docker://19.3.11
    ```

## Access the VMs

Each VM forming the Kubernetes cluster is accessible by using the private keys available in `/.secrets/`, by default.

The private key and host username used to access the machines are specified in `variables.tf`.

SSH to each machine using:
```
$ ssh -i .secrets/id_ed25519 <host_username>@<EXTERNAL_IP>
```

**_NOTE:_** SSH to the machines restricted to City Network and Customer VPNs only

## Rancher Setup

**_NOTE:_** All the following step are executed **manually** on the cluster

Log into the Rancher Control Panel before proceeding with the below steps.

### Storage Classes

The **Openstack Cinder Volume** Storage Class is used as storage backend to automatically create all required volumes by an applications.

1. Go to Cluster > Storage > Storage Classes

2. Add Class

3. Insert the following values:
    ```
    Name = cinder
    Provisioner = Openstack Cinder Volume
    ```
4. Leave all other parameters as default

5. Press `Save`

### Monitoring 
The Official Documentation is [here.](https://rancher.com/docs/rancher/v2.x/en/monitoring-alerting/)

#### Cluster Monitoring
1. Go to Cluster > Tools > Monitoring 

2. Edit the default configuration with the following values:
    ```
    Enable Node Exporter = false
    Enable Persistent Storage for Prometheus = true
    Default StorageClass for Prometheus = cinder
    Prometheus CPU Limit = 500
    Prometheus Memory Limit = 500
    Prometheus CPU Reservation = 350
    Prometheus Memory Reservation = 350
    Prometheus Operator Memory Limit
    ```
3. Leave all other parameters as default 

4. Press `Enable`

5. Wait a few minutes! Cluster Prometheus and Grafana Workloads will be deployed in your cluster under the **System** project.

6. Open the Cluster view to access the Grafana Dashboard
 
#### Project/Application Monitoring

1. Go to Default/Custom Project > Tools > Monitoring 

2. Edit the default configuration with the following values:
    ```
    Enable Persistent Storage for Prometheus = true
    Default StorageClass for Prometheus = cinder
    Prometheus CPU Limit = 500
    Prometheus Memory Limit = 500
    Prometheus CPU Reservation = 350
    Prometheus Memory Reservation = 350
    Prometheus Operator Memory Limit
    ```
3. Leave all other parameters as default

4. Press `Enable`

5. Wait a few minutes! Cluster Prometheus and Grafana Workloads will be deployed in your cluster under the **Default/Custom** project.

6. Go to Default/Custom Project > Resources > Workloads > `<app/workload>` > Workload Metrics to access the Grafana Dashboard

### Alerting
The Official Documentation is [here.](https://rancher.com/docs/rancher/v2.x/en/monitoring-alerting/)

1. Go to Cluster > Tool > Notifiers

2. Add the Slack Notifier using your Slack Workspace webhook.

3. Enable _"Send Resolved Alerts"_

4. Press `Test` and check you receive a notification in the defined Slack channel

5. Press `Add`

## Submariner
Submariner enables direct networking between Pods and Services in different Kubernetes clusters, either on-premises or in the cloud. 
With Submariner, your applications and services can span multiple cloud providers, data centers, and regions. 
https://submariner.io

### Infrastructure configuration

The Terraform configuration will:

- create 3 clusters: ClusterA, ClusterB, Broker
- set VPNaaS connection ClusterA ↔ Broker
- set VPNaaS connection ClusterB ↔ Broker
- add required UDP ports (500, 4500, 4800) opened on ClusterA and ClusterB

### Broker MANUAL configuration

#### 1. Deploy Broker 
   ```
   $ subctl --kubeconfig kubeconfig_broker.yml deploy-broker --kubecontext <broker_kubeconfig_cluster_name_with_local_ip_and_server_port_6443>
   ```
#### 2. Join ClusterA and ClusterB
   ```
   $ subctl join --kubeconfig kubeconfig_sto2.yml broker-info.subm --clusterid cluster-sto2
   ```
#### 3. Test connectivity
   ```
   $ subctl verify kubeconfig_fra1.yml kubeconfig_sto2.yml --only connectivity --verbose
   ...
   Ran 10 of 30 Specs in 141.650 seconds
   SUCCESS! -- 10 Passed | 0 Failed | 0 Pending | 20 Skipped
   ```
   
### Cleanup
The following commands help remove all Submariner pods from ClusterA, ClusterB and Broker cluster:
   ```
   $ kubectl --kubeconfig kubeconfig_sto2.yml delete crd clusters.submariner.io endpoints.submariner.io gateways.submariner.io multiclusterservices.lighthouse.submariner.io serviceimports.lighthouse.submariner.io submariners.submariner.io serviceexports.lighthouse.submariner.io http://serviceexports.lighthouse.submariner.io servicediscoveries.submariner.io
   $ kubectl --kubeconfig kubeconfig_sto2.yml delete ns submariner submariner-operator
   ```

# Limitations

1. Object Storage 
   
   Currently, object Storage (S3, Swift) is available only in Kna1, Fra1, Tky1, Dx1 in CityCloud. 
   
   By default, this configuration uses the Object Storage in the same region where the cluster is running. 
   
   The configuration in `buckets.tf` file should then be updated if Object Storage from another region is required.