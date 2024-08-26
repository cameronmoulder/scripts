<#
.SYNOPSIS
Automate the management of NSG rules.

.DESCRIPTION
This script automates the management of NSG rules by reading from a configuration file and applying the rules to specified NSGs.

.AUTHOR
Cameron Moulder
#>

# Parameters
$resourceGroupName = "myResourceGroup"
$nsgName = "myNSG"
$configFile = "C:\nsgRulesConfig.json"

# Load NSG rules configuration
$nsgRules = Get-Content -Path $configFile | ConvertFrom-Json

# Update NSG rules
foreach ($rule in $nsgRules) {
    $ruleName = $rule.name
    $priority = $rule.priority
    $direction = $rule.direction
    $access = $rule.access
    $protocol = $rule.protocol
    $sourceAddressPrefix = $rule.sourceAddressPrefix
    $sourcePortRange = $rule.sourcePortRange
    $destinationAddressPrefix = $rule.destinationAddressPrefix
    $destinationPortRange = $rule.destinationPortRange

    # Create or update NSG rule
    $nsgRule = New-AzNetworkSecurityRuleConfig -Name $ruleName -Protocol $protocol `
       -Direction $direction -Priority $priority -Access $access `
       -SourceAddressPrefix $sourceAddressPrefix -SourcePortRange $sourcePortRange `
       -DestinationAddressPrefix $destinationAddressPrefix -DestinationPortRange $destinationPortRange

    # Apply the rule to the NSG
    $nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Name $nsgName
    $nsg.SecurityRules.Add($nsgRule)
    Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg
}
