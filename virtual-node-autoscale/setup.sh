#!/bin/bash
<<COMMENT
This bash script requires that you have logged into your Azure account from the CLI and set your account to 
the subscription you wish to use to run the demo. You need to have helm installed.
COMMENT
read -p "Enter a cluster name: " cluster_name
read -p "Enter a resource group: " resource_group
echo "Creating resource group..."
az group create -g $resource_group -l westus
az provider register -n Microsoft.ContainerInstance
echo "Creating AKS cluster..."
az network vnet create --resource-group $resource_group --name myVnet --address-prefixes 10.0.0.0/8 --subnet-name myAKSSubnet --subnet-prefix 10.240.0.0/16
az network vnet subnet create --resource-group $resource_group --vnet-name myVnet --name myVirtualNodeSubnet --address-prefixes 10.241.0.0/16
SP=$(az ad sp create-for-rbac --skip-assignment --output json)
appId=$(echo $SP | jq -r .appId)
password=$(echo $SP | jq -r .password)
vnetId=$(az network vnet show --resource-group $resource_group --name myVnet --query id -o tsv)
az role assignment create --assignee $appId --scope $vnetId --role Contributor
subnetId=$(az network vnet subnet show --resource-group $resource_group --vnet-name myVnet --name myAKSSubnet --query id -o tsv)
az aks create \
    --resource-group $resource_group \
    --name $cluster_name \
    --node-count 1 \
    --network-plugin azure \
    --service-cidr 10.0.0.0/16 \
    --dns-service-ip 10.0.0.10 \
    --docker-bridge-address 172.17.0.1/16 \
    --vnet-subnet-id $subnetId \
    --service-principal $appId \
    --client-secret $password
az aks enable-addons \
    --resource-group $resource_group \
    --name $cluster_name \
    --addons virtual-node \
    --subnet-name myVirtualNodeSubnet
az aks get-credentials --resource-group $resource_group --name $cluster_name
echo "Initializing helm..."
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
echo "Checking connection to the cluster..."
kubectl get nodes
echo "Installing prometheus operator..."
kubectl apply -f https://raw.githubusercontent.com/coreos/prometheus-operator/master/bundle.yaml
kubectl apply -f online-store/prometheus-config/prometheus
kubectl expose pod prometheus-prometheus-0 --port 9090 --target-port 9090
echo "Checking for virtual node..."
kubectl get nodes
vk_node_name=virtual-node-aci-linux
echo "Adding http application routing..."
az aks enable-addons --resource-group $resource_group --name $cluster_name --addons http_application_routing
kubectl get svc --all-namespaces
ingress_external_ip=$(kubectl get svc -n kube-system -l app=addon-http-application-routing-nginx-ingress -o jsonpath="{.items[0].status.loadBalancer.ingress[0].ip}")
ingress_controller_namespace=kube-system
pod=$(kubectl get pods -n kube-system -l app=addon-http-application-routing-nginx-ingress  -o jsonpath="{.items[0].metadata.name}")
ingress_controller_class_annotation=$(kubectl -n $ingress_controller_namespace get po $ingress_controller_pod_name -o yaml | grep ingress-class | sed -e 's/.*=//')
echo "Deploying application..."
helm install ./charts/online-store --name online-store --set counter.specialNodeName=$vk_node_name,app.ingress.host=store.$ingress_external_ip.nip.io,appInsight.enabled=false,app.ingress.annotations."kubernetes\.io/ingress\.class"=$ingress_controller_class_annotation
echo "Installing prometheus metrics adaptor"
helm install stable/prometheus-adapter --name prometheus-adaptor -f ./online-store/prometheus-config/prometheus-adapter/values.yaml
kubectl get --raw /apis/custom.metrics.k8s.io/v1beta1/namespaces/default/pod/*/requests_per_second | jq .
echo "Hitting the online-store with some load"
export GOPATH=~/go
export PATH=$GOPATH/bin:$PATH
go get -u github.com/rakyll/hey
hey -z 20m http://$ingress_external_ip
kubectl get hpa online-store -w