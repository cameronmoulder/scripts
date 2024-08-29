### Active Directory Group and User Management

# 1. Create a New User
New-ADUser -Name "John Doe" -SamAccountName "jdoe" -UserPrincipalName "jdoe@domain.com" `
-Path "OU=Users,DC=domain,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force) `
-Enabled $true

# 2. Remove a User
Remove-ADUser -Identity "jdoe"

# 3. Add User to a Group
Add-ADGroupMember -Identity "GroupName" -Members "jdoe"

# 4. Remove User from a Group
Remove-ADGroupMember -Identity "GroupName" -Members "jdoe"

# 5. Create a New Group
New-ADGroup -Name "GroupName" -SamAccountName "GroupName" -GroupScope Global `
-Path "OU=Groups,DC=domain,DC=com"

# 6. Delete a Group
Remove-ADGroup -Identity "GroupName"

# 7. List Members of a Group
Get-ADGroupMember -Identity "GroupName"

# 8. List Groups of a User
Get-ADUser -Identity "jdoe" -Property MemberOf | Select-Object -ExpandProperty MemberOf

# 9. Enable a User Account
Enable-ADAccount -Identity "jdoe"

# 10. Disable a User Account
Disable-ADAccount -Identity "jdoe"

# 11. Move a User to a Different OU
Move-ADObject -Identity "CN=John Doe,OU=Users,DC=domain,DC=com" `
-TargetPath "OU=Admins,DC=domain,DC=com"

# 12. Rename a User Account
Rename-ADObject -Identity "CN=John Doe,OU=Users,DC=domain,DC=com" -NewName "Jonathan Doe"

# 13. Unlock a User Account
Unlock-ADAccount -Identity "jdoe"

# 14. Set Password for a User
Set-ADAccountPassword -Identity "jdoe" `
-NewPassword (ConvertTo-SecureString "NewP@ssw0rd!" -AsPlainText -Force)

# 15. Reset Password for a User (Requires Force)
Set-ADAccountPassword -Identity "jdoe" -Reset `
-NewPassword (ConvertTo-SecureString "NewP@ssw0rd!" -AsPlainText -Force)

# 16. Get a User's Details
Get-ADUser -Identity "jdoe" -Properties *

# 17. Search for Users in a Specific OU
Get-ADUser -Filter * -SearchBase "OU=Users,DC=domain,DC=com"

# 18. Get Group's Details
Get-ADGroup -Identity "GroupName" -Properties *

# 19. Check if a User is in a Group
Get-ADGroupMember -Identity "GroupName" | Where-Object { $_.SamAccountName -eq "jdoe" }

# 20. Export Group Membership to a CSV
Get-ADGroupMember -Identity "GroupName" | Select-Object Name,SamAccountName `
| Export-Csv -Path "C:\GroupMembers.csv" -NoTypeInformation


### Account Attribute Management

# 1. Modify User's Display Name
Set-ADUser -Identity "jdoe" -DisplayName "Johnathan Doe"

# 2. Update User's Email Address
Set-ADUser -Identity "jdoe" -EmailAddress "john.doe@domain.com"

# 3. Set User's Department
Set-ADUser -Identity "jdoe" -Department "IT"

# 4. Set User's Job Title
Set-ADUser -Identity "jdoe" -Title "Systems Administrator"

# 5. Set User's Manager
Set-ADUser -Identity "jdoe" -Manager "CN=Jane Smith,OU=Users,DC=domain,DC=com"

# 6. Update User's Office Location
Set-ADUser -Identity "jdoe" -Office "New York"

# 7. Modify User's Phone Number
Set-ADUser -Identity "jdoe" -OfficePhone "555-1234"

# 8. Set User's Mobile Number
Set-ADUser -Identity "jdoe" -MobilePhone "555-5678"

# 9. Set User's Street Address
Set-ADUser -Identity "jdoe" -StreetAddress "123 Main St"

# 10. Set User's City
Set-ADUser -Identity "jdoe" -City "New York"

# 11. Set User's State
Set-ADUser -Identity "jdoe" -State "NY"

# 12. Set User's Postal Code
Set-ADUser -Identity "jdoe" -PostalCode "10001"

# 13. Set User's Country
Set-ADUser -Identity "jdoe" -Country "US"

# 14. Set User's Company Name
Set-ADUser -Identity "jdoe" -Company "TechCorp"

# 15. Modify User's UPN (User Principal Name)
Set-ADUser -Identity "jdoe" -UserPrincipalName "john.doe@domain.com"

# 16. Update User's Logon Script
Set-ADUser -Identity "jdoe" -ScriptPath "logon.bat"

# 17. Set User's Profile Path
Set-ADUser -Identity "jdoe" -ProfilePath "\\server\profiles\jdoe"

# 18. Set User's Home Directory
Set-ADUser -Identity "jdoe" -HomeDirectory "\\server\home\jdoe" -HomeDrive "H:"

# 19. Set User's Description
Set-ADUser -Identity "jdoe" -Description "Senior Systems Administrator"

# 20. Set User's Password Never Expires
Set-ADUser -Identity "jdoe" -PasswordNeverExpires $true


### General Useful Commands

# 1. Check if AD Module is Installed
Get-WindowsFeature RSAT-AD-PowerShell

# 2. Import Active Directory Module
Import-Module ActiveDirectory

# 3. List All AD Users
Get-ADUser -Filter *

# 4. List All AD Groups
Get-ADGroup -Filter *

# 5. Find Users with Expired Passwords
Search-ADAccount -PasswordExpired

# 6. Find Disabled Accounts
Search-ADAccount -AccountDisabled

# 7. Find Locked Accounts
Search-ADAccount -LockedOut

# 8. Check if User's Password is Expired
Get-ADUser -Identity "jdoe" -Properties "msDS-UserPasswordExpiryTimeComputed" `
| Select-Object @{Name="PasswordExpired";Expression={$_."msDS-UserPasswordExpiryTimeComputed" -lt [datetime]::Now}}

# 9. Get AD Forest Information
Get-ADForest

# 10. Get AD Domain Information
Get-ADDomain

# 11. List All OUs
Get-ADOrganizationalUnit -Filter *

# 12. Get User Last Logon Time
Get-ADUser -Identity "jdoe" -Properties LastLogonDate | Select-Object Name, LastLogonDate

# 13. Export All Users to CSV
Get-ADUser -Filter * -Property DisplayName, EmailAddress | `
Select-Object DisplayName, EmailAddress | Export-Csv -Path "C:\AllUsers.csv" -NoTypeInformation

# 14. Search for Disabled User Accounts
Search-ADAccount -AccountDisabled -UsersOnly

# 15. Search for Inactive User Accounts
Search-ADAccount -AccountInactive -UsersOnly -TimeSpan 90

# 16. Find AD Schema Version
(Get-ADObject (Get-ADRootDSE).schemaNamingContext -Property objectVersion).objectVersion

# 17. List FSMO Role Holders
Get-ADDomain | Select-Object PDCEmulator, RIDMaster, InfrastructureMaster
Get-ADForest | Select-Object SchemaMaster, DomainNamingMaster

# 18. Find All Users in a Specific Group
Get-ADGroupMember -Identity "GroupName" -Recursive

# 19. Force Replication Between Domain Controllers
Sync-ADObject -Object (Get-ADUser -Identity "jdoe") -Source "DC1" -Destination "DC2"

# 20. Get Password Expiration Date for a User
(Get-ADUser -Identity "jdoe" -Properties msDS-UserPasswordExpiryTimeComputed).`
"msDS-UserPasswordExpiryTimeComputed" | ForEach-Object { $_.ToFileTimeUtc() }
