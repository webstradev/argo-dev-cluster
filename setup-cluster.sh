# bin/bash
kubectl create ns argocd

# Create the secret for the repository (needed for argo-cd)
./create-repo-secret.sh

# Create a temporary directory
tmpdir=$(mktemp -d)

# Install argo-cd using the manifest in the temporary directory
kubectl kustomize kustom/argo-cd/overlays --enable-helm --output $tmpdir/argo-cd.yaml
kubectl apply -f $tmpdir/argo-cd.yaml

rm -rf $tmpdir

# Install the apps (this includes the argo-cd app)
# That way it manages it self 
kubectl apply -k apps
