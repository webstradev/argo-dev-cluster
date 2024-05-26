# bin/bash
kubectl create ns argocd

# Create the secret for the repository (needed for argo-cd)
./create-repo-secret.sh

./create-sso-secret.sh

# Install argocd using the manifest
kubectl kustomize apps/argo-cd --enable-helm | kubectl apply -f -

# Install the apps (this includes the argo-cd app)
# That way it manages it self 
kubectl apply -k apps

# Remove the charts from your local machine
rm -rf apps/argo-cd/charts