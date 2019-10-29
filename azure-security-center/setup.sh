# SETUP before demo
az group create -g ASC-demo -l eastus
az aks create -n ASC-demo -g ASC-demo 
az aks get-credentials -n ASC-demo -g ASC-demo
# Time to create the problematic containers
kubectl create -f ASC-Trigger-AKS-Alerts.yaml
# This yaml file will create the malicious containers for us.
# Now we wait an hour for the Azure Security Center to detect these security threats.
# Navigate to https://ms.portal.azure.com/#blade/Microsoft_Azure_Security/SecurityMenuBlade/12 to review the security alerts
# Follow one of the recommendations to make your cluster healthier
# To reset, reset the recommendation and make your cluster unhealthy again

