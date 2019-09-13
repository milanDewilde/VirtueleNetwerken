echo "Installing AD-Domain-Services"
Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools
echo "Importing ADDSDeployment Service"
Import-Module ADDSDeployment
echo "Installing ADDSForest"
Install-ADDSForest -CreateDnsDelegation: $false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName "mdttest.com" -InstallDns: $true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion: $false -SysvolPath "C:\Windows\SYSVOL" -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "P@ssw0rd" -Force) -Force: $true