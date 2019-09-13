echo "Installing DNS Role"
Install-WindowsFeature -Name DNS -IncludeManagementTools
echo "Installing DHCP Role"
Install-WindowsFeature -Name DHCP -IncludeManagementTools
echo "Adding user to Enterprise Admins"
Add-ADGroupMember "Enterprise Admins" vagrant