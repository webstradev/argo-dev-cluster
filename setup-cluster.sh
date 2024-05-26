# bin/bash
# Create required namespaces for argocd and external-secrets
kubectl kustomize apps/namespaces | kubectl apply -f -

# Create secret for gitlab access token
./create-gitlab-secret.sh

# Install external-secrets using manifest 
kubectl kustomize apps/external-secrets --enable-helm | kubectl apply -f -

# Wait for the external-secrets-webhook deployment to be ready
echo "Waiting for external-secrets-webhook deployment to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment/external-secrets-webhook -n external-secrets

# Install the cluster secret store
# (this connects to gitlabs and initialises the store)
kubectl apply -k apps/cluster-secret-store

# Install argocd using the manifest
kubectl kustomize apps/argo-cd --enable-helm | kubectl apply -f -

# Install the apps using argocd (this will also create repo and sso secrets) 
# (argocd is one of these apps so now argocd manages itself)
kubectl apply -k apps

# Wait for all applications in the argocd namespace to be healthy and synced
echo "Waiting for Argo CD applications to be healthy and synced..."

while true; do
  all_healthy=true
  for app in $(kubectl get applications.argoproj.io -n argocd -o jsonpath='{.items[*].metadata.name}'); do
    health_status=$(kubectl get applications.argoproj.io $app -n argocd -o jsonpath='{.status.health.status}')
    sync_status=$(kubectl get applications.argoproj.io $app -n argocd -o jsonpath='{.status.sync.status}')
    if [ "$health_status" != "Healthy" ] || [ "$sync_status" != "Synced" ]; then
      all_healthy=false
      echo "Waiting for application $app to be healthy and synced..."
    fi
  done
  if [ "$all_healthy" = true ]; then
    break
  fi
  sleep 30
  echo "===== Retrying... ====="
done

echo "All Argo CD applications are healthy and synced."

# Remove the charts from your local machine (just some clean up)
rm -rf apps/argo-cd/charts 
rm -rf apps/external-secrets/charts

echo '<a href="argo.cluster.webstra.dev">Click here to go to Argo CD Dashboard</a>'
