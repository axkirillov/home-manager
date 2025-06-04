#!/bin/bash
#!/bin/bash

current_folder=$(basename "$PWD") # Used for fzf query
fixed_namespace="jq-shop-production"

# Fetch pods from the fixed namespace
pod_list=$(kubectl get pods --namespace "$fixed_namespace" --no-headers -o custom-columns=:metadata.name)

if [ $? -ne 0 ]; then
    # It's good practice to output errors to stderr
    echo "Error: kubectl failed to get pods from namespace '$fixed_namespace'. Please check your Kubernetes context and namespace." >&2
    exit 1
fi

if [ -z "$pod_list" ]; then
    echo "No pods found by kubectl in namespace '$fixed_namespace'. Exiting." >&2
    exit 1
fi

# Select a pod using fzf
# fzf prompt shows the fixed namespace, query still uses current_folder
pod=$(echo "$pod_list" | fzf --prompt="Select pod in '$fixed_namespace'> " --query="$current_folder")

# Check if a pod was selected
if [ -z "$pod" ]; then
    echo "No pod selected by fzf, exiting." >&2
    exit 1
fi

# Open an interactive shell in the selected pod
kubectl exec -it --namespace "$fixed_namespace" "$pod" -- /bin/bash
