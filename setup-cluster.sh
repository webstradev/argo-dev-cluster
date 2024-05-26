# bin/bash
# Create required namespaces for argocd and external-secrets
kubectl kustomize apps/namespaces | kubectl apply -f -

# Create secret for gitlab access token
./create-gitlab-secret.sh

# Install external-secrets using manifest 
kubectl kustomize apps/external-secrets --enable-helm | kubectl apply -f -

# Install the cluster secret store
# (this connects to gitlabs and initialises the store)
kubectl apply -k apps/cluster-secret-store

# Install argocd using the manifest
kubectl kustomize apps/argo-cd --enable-helm | kubectl apply -f -

# Install the apps using argocd (this will also create repo and sso secrets) 
# (argocd is one of these apps so now argocd manages itself)
kubectl apply -k apps

# Remove the charts from your local machine (just some clean up)
rm -rf apps/argo-cd/charts 
rm -rf apps/external-secrets/charts
