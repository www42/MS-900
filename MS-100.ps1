# MS-100
# Lab 1
# ---------

Get-Module -Name AzureAD
Disconnect-AzureAD
Connect-AzureAD
Get-AzureADTenantDetail | Format-List DisplayName, `
    @{n="TenantId";e={$_.ObjectId}}, `
    @{n="VerifiedDomains";e={$_.VerifiedDomains.Name}} 

Get-AzureADUser | fl *
Get-AzureADUser | ft DisplayName,UserType,DirSyncEnabled,LastDirSyncTime
    
Get-AzureAdSubscribedSku | fl *

$id = Get-AzureADMSDeletedGroup -Filter "DisplayName eq 'Inside Sales'" | % Id
Restore-AzureADMSDeletedDirectoryObject -Id $id
Get-AzureADMSGroup

dnscmd /zoneadd M365x19469767.onelearndns.com /DsPrimary
Resolve-DnsName -Name M365x19469767.onelearndns.com -Type TXT
Resolve-DnsName -Name autodiscover.M365x19469767.onelearndns.com -Type CNAME | fl


# Lab 2
# ---------
$tenantId = 'f32715f7-6c43-43e0-89d4-0d29204cccdd'
Connect-AzureAD -TenantId $tenantId
Get-AzureADTenantDetail | fl *
Get-AzureADDomain | Format-Table Name, IsVerified, IsDefault
$domain = Get-AzureADDomain | ? IsInitial -eq $true | % Name
$pattiF = Get-AzureADUser -ObjectId "PattiF@$domain"

# Role 'Service Support Administrator' is still not enabled from it's template.
# Get all enabled roles (only few)
Get-AzureADDirectoryrole 
# Get all role templates (102)
Get-AzureADDirectoryRoleTemplate
Get-AzureADDirectoryRoleTemplate | Measure-Object | % count
$serviceSupportRoleTemplate = Get-AzureADDirectoryRoleTemplate | ? DisplayName -eq 'Service Support Administrator'
gcm -Noun AzureADDirectoryrole
Enable-AzureADDirectoryrole -RoleTemplateId $serviceSupportRoleTemplate.ObjectId
$serviceSupportRole = Get-AzureADDirectoryrole | ? DisplayName -eq 'Service Support Administrator'

# Attention: Different ObjectIds
$serviceSupportRoleTemplate.ObjectId
$serviceSupportRole.ObjectId

Add-AzureADDirectoryRoleMember -ObjectId $serviceSupportRole.ObjectId -RefObjectId $pattiF.ObjectId

# Get all members of a specific role
$role = Get-AzureADDirectoryRole | ? DisplayName -eq 'Service Support Administrator'
$role = Get-AzureADDirectoryRole | ? DisplayName -eq 'Global Administrator'
Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId

# Get all roles of a specific user
$pattiF | fl *

# Lab 2 Exercise 1 Task 3 - Verify Delegated Administration
# Step 23-25 Lynne Robbins (User Administrator) soll Diego Siciliani's (Global Administrator) Password zurücksetzten 


Get-AzureADDomain | Format-Table Name, IsVerified, IsDefault
$initialDomainName = Get-AzureADDomain | ? IsInitial -eq $true | % Name
Set-AzureADDomain -Name $initialDomainName -IsDefault $true

Get-AzureAD 


# Lab 3
# ---------

# EXO
Get-Mailbox
Get-EXOMailbox
Get-EXOMailbox | ft UserPrincipalName,RecipientTypeDetails

Get-Mailbox -Identity JoniS@M365x19469767.OnMicrosoft.com | Set-Mailbox -ExtensionCustomAttribute1 "bar"
Get-Mailbox -Identity JoniS@M365x19469767.OnMicrosoft.com | fl *