# argo-dev-cluster
GitOps repository to control my playground / development cluster.

The underlying infrastructure is managed in https://github.com/webstradev/bootstrap-do-cluster

## GitOps
The aim for this repo was to have a completely automated cluster (cattle not pets) which can easily be torn down and recreated.

The entire cluster can be bootstrapped by having the appropriate secrets set up in gitlab variables (I know not really a secret store, but its free and simple) and running one command:
./setup-cluster.sh

This will ask to provide an access token to access the gitlab secrets and the rest is done automatically.


