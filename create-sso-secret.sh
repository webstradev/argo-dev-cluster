#!/bin/bash

# Prompt for GitHub OAuth client ID, client secret and org
read -p "Enter your GitHub OAuth client ID: " CLIENT_ID
read -p "Enter your GitHub OAuth client secret: " CLIENT_SECRET
read -p "Enter your GitHub organization: " ORG


# Create the Kubernetes secret with the correct name, structure, and label
kubectl create secret generic argocd-sso-key \
  --namespace argocd \
  --from-literal=dex.github.org="$ORG" \
  --from-literal=dex.github.clientID="$CLIENT_ID" \
  --from-literal=dex.github.clientSecret="$CLIENT_SECRET" \
  --dry-run=client -o yaml | kubectl label --local -f - app.kubernetes.io/part-of=argocd -o yaml | kubectl apply -f -

echo "Kubernetes secret 'argocd-sso-key' created in namespace 'argocd'."