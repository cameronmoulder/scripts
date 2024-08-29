# ============================
# Exchange PowerShell Cheat Sheet
# ============================

# ----------------------------
# Section 1: Installing and Importing Exchange Module
# ----------------------------

# 1. Install the Exchange Online Management Module from the PowerShell Gallery
Install-Module -Name ExchangeOnlineManagement

# 2. Import the Exchange Online Management Module into your PowerShell session
Import-Module ExchangeOnlineManagement

# 3. Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName <your-email> -ShowProgress $true

# 4. Connect to an on-premises Exchange server
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<ExchangeServer>/PowerShell/ -Authentication Kerberos
Import-PSSession $Session -DisableNameChecking

# 5. Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false

# ----------------------------
# Section 2: Granting/Checking Permissions on Exchange Objects
# ----------------------------

# 1. Grant full mailbox access to a user
Add-MailboxPermission -Identity <Mailbox> -User <User> -AccessRights FullAccess -InheritanceType All

# 2. Check who has full access to a mailbox
Get-MailboxPermission -Identity <Mailbox> | Where-Object { $_.AccessRights -eq "FullAccess" }

# 3. Grant Send As permission on a mailbox
Add-ADPermission -Identity <Mailbox> -User <User> -ExtendedRights "Send As"

# 4. Check who has Send As permission on a mailbox
Get-ADPermission -Identity <Mailbox> | Where-Object { $_.ExtendedRights -contains "Send As" }

# 5. Grant Send on Behalf permission to a user
Set-Mailbox -Identity <Mailbox> -GrantSendOnBehalfTo <User>

# 6. Check who has Send on Behalf permission on a mailbox
(Get-Mailbox -Identity <Mailbox>).GrantSendOnBehalfTo

# 7. Grant calendar folder permissions
Add-MailboxFolderPermission -Identity <Mailbox>:\Calendar -User <User> -AccessRights Editor

# 8. Check calendar folder permissions
Get-MailboxFolderPermission -Identity <Mailbox>:\Calendar

# 9. Grant permission to view a mailbox
Add-MailboxPermission -Identity <Mailbox> -User <User> -AccessRights ReadPermission -InheritanceType All

# 10. Revoke full access permission from a user
Remove-MailboxPermission -Identity <Mailbox> -User <User> -AccessRights FullAccess -InheritanceType All

# 11. Grant access to a specific folder in a mailbox
Add-MailboxFolderPermission -Identity <Mailbox>:\<FolderName> -User <User> -AccessRights Reviewer

# 12. Check who has access to a specific folder in a mailbox
Get-MailboxFolderPermission -Identity <Mailbox>:\<FolderName>

# 13. Grant management role to a user
New-ManagementRoleAssignment -Role "<RoleName>" -User <User>

# 14. Check management roles assigned to a user
Get-ManagementRoleAssignment -RoleAssignee <User>

# 15. Grant mailbox import/export permission
New-ManagementRoleAssignment –Role "Mailbox Import Export" –User <User>

# 16. Check if a user has mailbox import/export permission
Get-ManagementRoleAssignment –RoleAssignee <User> –Role "Mailbox Import Export"

# 17. Grant delegation permission to a mailbox
Add-MailboxPermission -Identity <Mailbox> -User <User> -AccessRights "ExternalAccount" -InheritanceType All

# 18. Check all permissions for a mailbox
Get-MailboxPermission -Identity <Mailbox>

# 19. Grant permission to send emails as a distribution group
Add-RecipientPermission -Identity <DistributionGroup> -Trustee <User> -AccessRights SendAs

# 20. Check who has permission to send as a distribution group
Get-RecipientPermission -Identity <DistributionGroup> | Where-Object { $_.AccessRights -contains "SendAs" }

# ----------------------------
# Section 3: Creating Objects in Exchange
# ----------------------------

# 1. Create a new mailbox
New-Mailbox -Name <Name> -UserPrincipalName <UPN> -Password (ConvertTo-SecureString -String "<Password>" -AsPlainText -Force)

# 2. Create a new shared mailbox
New-Mailbox -Name <SharedMailboxName> -Shared

# 3. Create a new distribution group
New-DistributionGroup -Name <GroupName> -PrimarySmtpAddress <email@domain.com>

# 4. Create a new dynamic distribution group
New-DynamicDistributionGroup -Name <GroupName> -RecipientFilter {(RecipientType -eq 'UserMailbox')}

# 5. Create a new security group
New-DistributionGroup -Name <GroupName> -Type Security

# 6. Create a new room mailbox
New-Mailbox -Name <RoomName> -Room

# 7. Create a new equipment mailbox
New-Mailbox -Name <EquipmentName> -Equipment

# 8. Create a new mailbox database
New-MailboxDatabase -Name <DBName> -Server <ServerName>

# 9. Create a new public folder
New-PublicFolder -Name <FolderName> -Path "\"

# 10. Create a new public folder mailbox
New-Mailbox -PublicFolder -Name <PublicFolderMailboxName>

# 11. Create a new address list
New-AddressList -Name <ListName> -RecipientFilter {(RecipientType -eq 'UserMailbox')}

# 12. Create a new offline address book (OAB)
New-OfflineAddressBook -Name <OABName> -AddressLists "\Default Global Address List"

# 13. Create a new retention policy
New-RetentionPolicy -Name <PolicyName> -RetentionPolicyTagLinks "<Tag1>","<Tag2>"

# 14. Create a new retention policy tag
New-RetentionPolicyTag -Name <TagName> -Type All -RetentionEnabled $true -RetentionAction PermanentlyDelete -AgeLimitForRetention 365

# 15. Create a new accepted domain
New-AcceptedDomain -Name <DomainName> -DomainName domain.com -DomainType Authoritative

# 16. Create a new email address policy
New-EmailAddressPolicy -Name <PolicyName> -IncludedRecipients AllRecipients -EnabledEmailAddressTemplates "SMTP:%m@domain.com"

# 17. Create a new mailbox export request
New-MailboxExportRequest -Mailbox <Mailbox> -FilePath "\\Server\Share\MailboxExport.pst"

# 18. Create a new mailbox import request
New-MailboxImportRequest -Mailbox <Mailbox> -FilePath "\\Server\Share\MailboxImport.pst"

# 19. Create a new Outlook Web App mailbox policy
New-OwaMailboxPolicy -Name <PolicyName> -DirectFileAccessOnPublicComputersEnabled $false

# 20. Create a new mobile device mailbox policy
New-MobileDeviceMailboxPolicy -Name <PolicyName> -AllowNonProvisionableDevices $true

# ----------------------------
# Section 4: Converting Exchange Objects
# ----------------------------

# 1. Convert a mailbox to a shared mailbox
Set-Mailbox -Identity <Mailbox> -Type Shared

# 2. Convert a shared mailbox to a regular user mailbox
Set-Mailbox -Identity <Mailbox> -Type Regular

# 3. Convert a distribution group to a security group
Set-DistributionGroup -Identity <GroupName> -Type Security

# 4. Convert a security group to a distribution group
Set-DistributionGroup -Identity <GroupName> -Type Distribution

# 5. Convert a user mailbox to a room mailbox
Set-Mailbox -Identity <Mailbox> -Type Room

# 6. Convert a room mailbox to a user mailbox
Set-Mailbox -Identity <Mailbox> -Type Regular

# 7. Convert a user mailbox to an equipment mailbox
Set-Mailbox -Identity <Mailbox> -Type Equipment

# 8. Convert an equipment mailbox to a user mailbox
Set-Mailbox -Identity <Mailbox> -Type Regular

# 9. Convert a public folder mailbox to a regular mailbox
Set-Mailbox -Identity <Mailbox> -PublicFolder $false

# 10. Convert a regular mailbox to a public folder mailbox
Set-Mailbox -Identity <Mailbox> -PublicFolder $true

# 11. Convert a public folder to a mail-enabled public folder
Enable-MailPublicFolder -Identity "\PublicFolders\FolderName"

# 12. Convert a mail-enabled public folder to a regular public folder
Disable-MailPublicFolder -Identity "\PublicFolders\FolderName"

# 13. Convert an offline address book (OAB) to web-distributed
Set-OfflineAddressBook -Identity <OABName> -DistributionMethod Web

# 14. Convert an offline address book (OAB) to public folder distributed
Set-OfflineAddressBook -Identity <OABName> -DistributionMethod PublicFolder

# 15. Convert a mailbox to a linked mailbox
Set-Mailbox -Identity <Mailbox> -LinkedMasterAccount <MasterAccount> -LinkedDomainController <DomainController>

# 16. Convert a linked mailbox to a regular mailbox
Set-Mailbox -Identity <Mailbox> -LinkedMasterAccount $null -LinkedDomainController $null

