# bin/bash
kubectl create ns argocd

# Create the secret for the repository (needed for argo-cd)
./create-repo-secret.sh

