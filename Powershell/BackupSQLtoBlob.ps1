<#
.SYNOPSIS
Backup Azure SQL Database to Azure Blob Storage.

.DESCRIPTION
This script backs up an Azure SQL Database to Azure Blob Storage using the database export method.

.AUTHOR
Cameron Moulder
#>

# Parameters
$resourceGroupName = "myResourceGroup"
$serverName = "mySqlServer"
$databaseName = "myDatabase"
$storageAccountName = "mystorageaccount"
$containerName = "backups"
$blobName = "$databaseName.bacpac"
$credentialName = "myCredential"

# Export Database
New-AzSqlDatabaseExport `
  -ResourceGroupName $resourceGroupName `
  -ServerName $serverName `
  -DatabaseName $databaseName `
  -StorageKeyType "StorageAccessKey" `
  -StorageKey (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -AccountName $storageAccountName).Value[0] `
  -StorageUri ("https://" + $storageAccountName + ".blob.core.windows.net/" + $containerName + "/" + $blobName) `
  -AdministratorLogin "sqladmin" `
  -AdministratorLoginPassword (ConvertTo-SecureString -String "YourPassword" -AsPlainText -Force)
