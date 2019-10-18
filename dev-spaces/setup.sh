az group create --name dev-spaces-demo --location eastus
az aks create -g dev-spaces-demo -n dev-spaces-demo --location eastus --disable-rbac --generate-ssh-keys
az aks use-dev-spaces -g dev-spaces-demo -n dev-spaces-demo --space dev --yes
azds show-context
# Insert the hostname from the command above into the values.yaml file
git clone https://github.com/Azure/dev-spaces
cd dev-spaces\samples\BikeSharingApp\charts
helm init --wait
# Here's where the demo starts
helm install -n bikesharing . --dep-up --namespace dev --atomic
azds list-uris
# Navigate to the bike sharing website through the public URL from the list
# Create two different devspaces
azds space select -n dev/azureuser1 -y
azds space select -n dev/azureuser2 -y
# Verify the dev spaces have been created and that azureuser2 is selected
azds space list
# Look! There are different urls for all of the devspaces
azds list-uris
# Now, open up BikesharingWeb/components/Header.js and make some changes

azds up
# Go to the URL and see the change you made

#Reset mechanism 
azds remove -n dev-spaces-demo -g dev-spaces-demo --yes