<#
.SYNOPSIS
Automated Azure resource cleanup script.

.DESCRIPTION
This script identifies and cleans up unused resources in an Azure subscription.

.AUTHOR
Cameron Moulder
#>

# Login to Azure
Connect-AzAccount

# Select the subscription to clean up
$subscriptionId = "Your-Subscription-ID"
Select-AzSubscription -SubscriptionId $subscriptionId

# Find stopped VMs
$stoppedVMs = Get-AzVM | Where-Object { $_.PowerState -eq "VM deallocated" }
foreach ($vm in $stoppedVMs) {
    Write-Host "Deleting VM:" $vm.Name
    Remove-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force
}

# Find unattached disks
$unattachedDisks = Get-AzDisk | Where-Object { $_.DiskState -eq "Unattached" }
foreach ($disk in $unattachedDisks) {
    Write-Host "Deleting unattached disk:" $disk.Name
    Remove-AzDisk -ResourceGroupName $disk.ResourceGroupName -DiskName $disk.Name -Force
}

# Find orphaned public IPs
$orphanedIPs = Get-AzPublicIpAddress | Where-Object { $_.IpConfiguration -eq $null }
foreach ($ip in $orphanedIPs) {
    Write-Host "Deleting orphaned public IP:" $ip.Name
    Remove-AzPublicIpAddress -ResourceGroupName $ip.ResourceGroupName -Name $ip.Name -Force
}
