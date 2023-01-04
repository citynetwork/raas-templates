# Prerequisites
## Object storage
These scripts expect an S3-compatible bucket for automated backups of the cluster state.
Instructions on how to create one can be found here:
https://cleura.cloud/storage/objectstorage

## Rancher
You'll need an access key and a secret key from RaaS.
This can be created under your user (on the top right in the UI) "Account and API Keys" and "Create API Key".
Take notes of these as they can not to retrieved again.

## OpenStack
You need to create an OpenStack user with permissions to create resources.
This can be done here:
https://cleura.cloud/users/openstack

## SSH
You'll need to provide a SSH keypair which in turn will be created as an OpenStack keypair.
This key needs to be placed in $PWD/.secrets
A key using ed25519 is expected.
You can either provide your own key or create a new one:
```bash
$ ssh-keygen -t ed25519
```