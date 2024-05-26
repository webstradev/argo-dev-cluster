# bin/bash
kubectl create ns argocd
kubectl create ns external-secrets

# Create secret for gitlab access token
./create-gitlab-secret.sh

# Install external-secrets
kubectl apply -k apps/external-secrets

./create-repo-secret.sh

./create-sso-secret.sh

# Install argocd using the manifest
kubectl kustomize apps/argo-cd --enable-helm | kubectl apply -f -

# Install the apps (this includes the argo-cd app)
# That way it manages it self 
kubectl apply -k apps

# Remove the charts from your local machine
rm -rf apps/argo-cd/charts