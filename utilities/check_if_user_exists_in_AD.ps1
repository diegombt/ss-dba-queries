###############################################################################################################
# Check if AD user exists with PowerShell
# https://morgantechspace.com/2016/11/check-if-ad-user-exists-with-powershell.html
###############################################################################################################

# Install Module → https://morgantechspace.com/2015/02/how-to-import-active-directory-module-in-powershell.html

# Import Module
Import-Module ActiveDirectory

# Declare Users
$users = @("CAREYESM","EFRODRIGUEZM","LNGARZONR","YEGARCESH", "DMBERNALT")

# Get user status
foreach ($user in $users) {
$userobj = $(try {Get-ADUser $user} catch {$Null})
If ($userobj -ne $Null) {
    Write-Host "$user already exists" -foregroundcolor "green"
} else {
    Write-Host "$user not found " -foregroundcolor "red"
}}