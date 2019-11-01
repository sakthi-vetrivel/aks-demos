# SETUP before demo
az group create -g ASC-demo -l eastus
az aks create -n ASC-demo -g ASC-demo --kubernetes-version 1.10.12 --disable-rbac
az aks get-credentials -n ASC-demo -g ASC-demo
