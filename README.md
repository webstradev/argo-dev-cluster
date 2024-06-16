# argo-dev-cluster
GitOps repository to control my playground / development cluster.

I have made this public as I wanted to share my struggles in setting up a cluster like this. GitOps / ArgoCD / Terraform all amazing, but you will lose some time in the beginning playing with how you set up your cluster.

I'm not saying this is THE way to do it, but I like this pattern.

## Underlying infra

The underlying infrastructure is managed in https://github.com/webstradev/bootstrap-do-cluster

## GitOps
The aim for this repo was to have a completely automated cluster (cattle not pets) which can easily be torn down and recreated.

The entire cluster can be bootstrapped by having the appropriate secrets set up in gitlab variables (I know not really a secret store, but its free and simple) and running one command:
./setup-cluster.sh

This will ask to provide an access token to access the gitlab secrets and the rest is done automatically.


