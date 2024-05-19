#!/bin/bash

# Prompt for SSH key location, GitHub username, and repository name
read -p "Enter the SSH key location (default: ~/.ssh/argocd): " SSH_KEY_LOCATION
SSH_KEY_LOCATION=${SSH_KEY_LOCATION:-~/.ssh/argocd}

read -p "Enter your GitHub username (default: webstradev): " GITHUB_USERNAME
GITHUB_USERNAME=${GITHUB_USERNAME:-'webstradev'}

read -p "Enter your repository name (default: argo-dev-cluster): " REPO_NAME
REPO_NAME=${REPO_NAME:-'argo-dev-cluster'}

# Read the SSH private key
SSH_PRIVATE_KEY=$(cat $SSH_KEY_LOCATION)

# Create the Kubernetes secret with the correct label and structure
kubectl create secret generic argocd-repo-secret\
  --namespace argocd \
  --from-literal=type=git \
  --from-literal=url=git@github.com:$GITHUB_USERNAME/$REPO_NAME.git \
  --from-literal=sshPrivateKey="$SSH_PRIVATE_KEY" \
  --dry-run=client -o yaml | kubectl label --local -f - argocd.argoproj.io/secret-type=repository -o yaml | kubectl apply -f -
