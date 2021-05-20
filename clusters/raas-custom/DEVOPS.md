# DevOps

## Cluster Scale UP / DOWN

### Add new **Master** or **Worker** nodes

- Edit _n_of_master_nodes_ or _n_of_worker_nodes_ in `variables.tf`
- Run Terraform apply

### Remove **Worker** nodes 
- Edit _n_of_worker_nodes_ in `variables.tf`
- Run Terraform apply

### Remove **Master** nodes 
- MANUALLY delete the nodes from the `Cluster > Nodes` view in Rancher UI. 
    ```
    WARNING. Always remove nodes with biggest digits!  
    ```
- Edit _n_of_worker_nodes_ in `variables.tf`
- Run Terraform apply
    ```
    NOTE. Removing Master nodes directly via variables.tf is currently not supported due to a bug in Rancher: 
    https://github.com/rancher/rancher/issues/19916
    ```

### Update kubeconfig file
- Run `$ terraform apply --target local.kube_config` when the Rancher cluster is fully updated 

## Restore from snapshot
In case of any issue caused by a mismatch between the Rancher Cluster configuration and the infrastructure nodes, 
simply **restore from snapshot:**
`Cluster > ⋮ > Restore Snapshot`

