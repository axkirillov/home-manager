#!/bin/bash

current_folder=$(basename "$PWD")

# Select a pod using fzf
pod=$(kubectl get pods --no-headers -o custom-columns=:metadata.name | fzf --prompt="Select pod> " --query="$current_folder")

# Check if a pod was selected
if [ -z "$pod" ]; then
    echo "No pod selected, exiting."
    exit 1
fi

# Open an interactive shell in the selected pod
kubectl exec -it "$pod" -- /bin/bash
