# To set-up this demo, do the following:

# Join preview for Azure Policy with AKS
# Create an AKS cluster
# Add a 'Do not allow privileged containers' policy on the cluster
# Wait for the policy to create (15 minutes)
# Enable Policy Add-on for the cluster

# Creating resource group

# Creating cluster
az aks create -n azure-policy -g azure-policy-rg --node-count 1 
# Enable Azure Policy on this cluster
az aks enable-addons --addons azure-policy --name azure-policy --resource-group azure-policy-rg

# Creating policy
az policy assignment create --name 'denyCoolTiering' --description 'Deny cool access tiering for storage' --scope  '{
    "if": {
        "allOf": [{
                "field": "type",
                "equals": "Microsoft.Storage/storageAccounts"
            },
            {
                "field": "kind",
                "equals": "BlobStorage"
            },
            {
                "field": "Microsoft.Storage/storageAccounts/accessTier",
                "equals": "cool"
            }
        ]
    },
    "then": {
        "effect": "deny"
    }
}'