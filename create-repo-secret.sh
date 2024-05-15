#!/bin/bash

# Prompt for SSH key location, GitHub username, and repository name
read -p "Enter the SSH key location (default: ~/.ssh/id_rsa): " SSH_KEY_LOCATION
SSH_KEY_LOCATION=${SSH_KEY_LOCATION:-~/.ssh/id_rsa}

read -p "Enter your GitHub username (default: webstradev): " GITHUB_USERNAME
GITHUB_USERNAME=${GITHUB_USERNAME:-'webstradev'}
read -p "Enter your repository name: (default: argo-dev-cluster)" REPO_NAME
REPO_NAME=${REPO_NAME:-'argo-dev-cluster'}

# Base64 encode the SSH private key
SSH_PRIVATE_KEY=$(cat $SSH_KEY_LOCATION | base64 | tr -d '\n')

# Create the Kubernetes secret with the necessary label
kubectl create secret generic argocd-repo-secret \
  --namespace argocd \
  --from-literal=url=git@github.com:$GITHUB_USERNAME/$REPO_NAME.git \
  --from-literal=sshPrivateKey=$SSH_PRIVATE_KEY \
  --dry-run=client -o yaml | kubectl label --local -f - argocd.argoproj.io/secret-type=repository -o yaml | kubectl apply -f -
