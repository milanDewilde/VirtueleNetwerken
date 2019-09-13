echo "Adding DHCP Server To Domain Controller"
Add-DhcpServerInDC
echo "Setting DHCP Scope"
Add-DhcpServerv4Scope -Name "MDTTEST IPv4" -StartRange 192.168.2.4 -EndRange 192.168.2.254 -SubnetMask 255.255.255.0
echo "Adding AD Service Account User"
New-ADUser -Name "MDT_JD" -DisplayName "MDT_JD" -GivenName "MDT_JD" -UserPrincipalName "MDT_JD@mdttest.com" -AccountPassword (ConvertTo-SecureString -AsPlainText "P@ssw0rd" -Force) -Path "CN=Managed Service Accounts,DC=mdttest,DC=com" -PasswordNeverExpires $true -CannotChangePassword $true -ChangePasswordAtLogon $false -Enabled $true
echo "Adding MDT Service Account User"
New-ADUser -Name "MDT_BA" -DisplayName "MDT_BA" -GivenName "MDT_BA" -UserPrincipalName "MDT_BA@mdttest.com" -AccountPassword (ConvertTo-SecureString -AsPlainText "P@ssw0rd" -Force) -Path "CN=Managed Service Accounts,DC=mdttest,DC=com" -PasswordNeverExpires $true -CannotChangePassword $true -ChangePasswordAtLogon $false -Enabled $true
echo "Setting Powershell Execution Policy"
powershell Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
echo "Setting Location to C:\Setup\Scripts"
Set-Location C:\Setup\Scripts
echo "Setting OU Permissions"
#Computers is a CN instead of an OU in default AD-Forest installation, hence the change in parameter
.\Set-OUPermissions.ps1 -Account MDT_JD -TargetOU "CN=Computers"