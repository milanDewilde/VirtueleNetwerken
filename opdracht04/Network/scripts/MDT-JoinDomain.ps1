echo "Changing DNS to Domain Controller DNS"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses("192.168.2.2","10.0.2.15")
echo "Adding Computer to domain"
$password = ConvertTo-SecureString -AsPlainText "vagrant" -Force
$credential = New-Object System.Management.Automation.PSCredential("vagrant",$password)
Add-Computer -DomainName "mdttest.com" -Credential $credential -PassThru -Verbose -Force -Restart