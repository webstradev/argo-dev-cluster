#!/bin/bash
# Prompt for Gitlab token name and access_token 
read -p "Enter the Gitlab token name (default: k3s-dev-cluster): " GITLAB_TOKEN_NAME 
GITLAB_TOKEN_NAME=${GITLAB_TOKEN_NAME:-k3s-dev-cluster}
read -s -p "Enter your Gitlab access token: " GITLAB_ACCESS_TOKEN

# Create kubernetes secret
kubectl create secret generic gitlab-token\
  --namespace external-secrets \
  --from-literal=token_name="$GITLAB_TOKEN_NAME" \
  --from-literal=token="$GITLAB_ACCESS_TOKEN" \
  --dry-run=client -o yaml | kubectl apply -f -