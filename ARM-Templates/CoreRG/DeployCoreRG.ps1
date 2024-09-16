#Import The Module
Import-Module az

#Prompt User For Command
$deployordestroy = Read-Host "Enter command (deploy or destroy)?"

# Check the command entered by the user
if ($deployordestroy -eq "deploy") {
    # Get RG Name
  $RGname = (Read-Host = "What are we naming the RG?")
    $location = (Read-Host = "Where are we deploying to?")
        #Prompt for Login
        az login;
        #Create RG
        az group create --name $RGname --location $location
        #Deploy template (#vnets and nsg's)
        az deployment group create --resource-group CoreRG --template-file ~/Documents/ExportedTemplate-CoreRG/template.json --parameters ~/Documents/ExportedTemplate-CoreRG/parameters.json
        #Show the deployed resources
        az resource list --resource-group CoreRG
}
elseif ($deployordestroy -eq "destroy") {
    
    az group delete --name CoreRG --yes
}
else {
    Write-Host "Invalid command. Please enter 'deploy' or 'destroy'."
}

