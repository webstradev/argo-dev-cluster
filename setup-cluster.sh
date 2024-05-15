# bin/bash
kubectl create ns argocd

# Create the secret for the repository (needed for argo-cd)
./create-repo-secret.sh

# Install argo=cd using the manifest
kubectl kustomize kustom/argo-cd/overlays --enable-helm | kubectl apply -f -

# Install the apps (this includes the argo-cd app)
# That way it manages it self 
kubectl apply -k apps
