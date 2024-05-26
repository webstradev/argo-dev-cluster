# bin/bash
kubectl create ns argocd
kubectl create ns external-secrets

# Create secret for gitlab access token
./create-gitlab-secret.sh

# Install external-secrets using manifest 
kubectl kustomize apps/external-secrets --enable-helm | kubectl apply -f -

kubectl apply -k apps/cluster-secret-store

# Install argocd using the manifest
kubectl kustomize apps/argo-cd --enable-helm | kubectl apply -f -

# Install the apps (this includes the argo-cd app)
# (now argocd manages itself)
kubectl apply -k apps

# Remove the charts from your local machine
rm -rf apps/argo-cd/charts
rm -rf apps/external-secrets/charts