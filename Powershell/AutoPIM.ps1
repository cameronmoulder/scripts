
#Install the module
Install-module -Name AzureADPreview

#Import the module
Import-Module AzureADPreview

#Set Schedule to Today + 1 minute and Today 8 hours from now
$schedule = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedSchedule
$schedule.Type = "Once"
$schedule.StartDateTime = (Get-Date).AddMinutes(3)
$schedule.endDateTime = (Get-Date).AddHours(8)



#Get token for MS Graph by prompting for MFA
$MsResponse = Get-MSALToken -Scopes @("https://graph.microsoft.com/.default") -ClientId <client ID> -RedirectUri "urn:ietf:wg:oauth:2.0:oob" -Authority "https://login.microsoftonline.com/common" -Interactive -ExtraQueryParameters @{claims='{"access_token" : {"amr": { "values": ["mfa"] }}}'}


# Get token for AAD Graph
$AadResponse = Get-MSALToken -Scopes @("https://graph.windows.net/.default") -ClientId <client ID> -RedirectUri "urn:ietf:wg:oauth:2.0:oob" -Authority "https://login.microsoftonline.com/common"


Connect-AzureAD -AadAccessToken $AadResponse.AccessToken -MsAccessToken $MsResponse.AccessToken -AccountId: <UPN> -tenantId: <Tenant ID>

# Call cmdlet which requires MFA
$resource = Get-AzureADMSPrivilegedResource -ProviderId AadRoles

$roleDefinition = Get-AzureADMSPrivilegedRoleDefinition  -ProviderId AadRoles -ResourceId $resource.Id -Filter "DisplayName eq <Role>

$subject = Get-AzureADUser -Filter "userPrincipalName eq <UPN>"

Open-AzureADMSPrivilegedRoleAssignmentRequest -ProviderId AadRoles -Schedule $schedule -ResourceId $resource.Id -RoleDefinitionId $roleDefinition.Id -SubjectId $subject.ObjectId -AssignmentState "Active" -Type "UserAdd" -Reason "Elevating Role to do X"

