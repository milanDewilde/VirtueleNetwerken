##Variables

$siteName="Testsite"            #Name site in IIS
$instanceName = ".\SQLEXPRESS"  #Name SQL Server Instance
$loginName = "user"             #SQL Server User Name
$password = "test123"           #SQL Server User Password
$database = "TestDatabase"      #SQL Database

##Normally No Need To Change Anything Below This Line
##--------------------------------------------------------------------

##Install Chocolatey

##Check if Chocolatey is installed, check for updates otherwise. Will never trigger on initial provision, but saves time when rerunning vagrant provision
If(Get-Command choco.exe -ErrorAction SilentlyContinue) {
	echo "Chocolatey already installed, checking for updates."
	choco upgrade chocolatey -y
} Else {
	echo "Installing Chocolatey."
	Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

##Install IIS

echo "Installing IIS."
Install-WindowsFeature -name Web-Server -IncludeManagementTools

##Install .NET 4.7.2

echo "Installing .NET 4.7.2"
choco install dotnetfx -y

##Install ASP.NET

echo "Installing ASP.NET."
Install-WindowsFeature -name Web-Asp-Net45

##Setup ASP.NET Application

##Adding appcmd.exe to PATH
echo "Adding appcmd.exe to PATH."
$env:Path += ";C:\Windows\system32\inetsrv\"

###Delete IIS default website
if (appcmd list site /name:"Default Web Site" -ne $null){
	echo "Deleting Default Web Site."
	appcmd delete site "Default Web Site"
} else {
	echo "Default Web Site already deleted."
}

##Remove Application folder for a clean install of the ASP.NET app
if (Test-Path -Path C:\Application -PathType Container) {
	appcmd stop site /site.name:$siteName
	echo "Removing Application folder."
	Remove-Item -Path C:\Application -Force -Recurse
	appcmd start site /site.name:$siteName
}

##Create Application folder anew and copy ASP.NET files
echo "Creating Application folder and copying application files from synced folder."
New-Item -ItemType Directory -Force -Path C:\Application
Copy-Item -Path C:\Applicationsource\* -Recurse -Destination c:\Application\

##Add Site and ASP.NET webapp to IIS
if (appcmd list site /name:$siteName -ne $null){
	echo "Web App already added to IIS."	
} else {
	echo "Adding Web App to IIS."
	appcmd add site /name:$siteName /id:1 /physicalPath:c:\application /bindings:'http/*:80:'
	appcmd add app /site.name:$siteName /path:/application /physicalPath:c:\application
}

##Install SQL-Server

echo "Installing SQL-Server."
choco install sql-server-management-studio -y

choco install -y sql-server-express

# update $env:PSModulePath to include the modules installed by recently installed Chocolatey packages.
$env:PSModulePath = "$([Environment]::GetEnvironmentVariable('PSModulePath', 'User'));$([Environment]::GetEnvironmentVariable('PSModulePath', 'Machine'))"

#import SQL Server module
Import-Module SQLPS -DisableNameChecking

$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName
$server.Settings.LoginMode = 'Mixed'
$server.Alter()

# drop login if it existst
if ($server.Logins.Contains($loginName))  
{   
    Write-Host("Deleting the existing login $loginName.")
       $server.Logins[$loginName].Drop() 
}

$login = New-Object `
-TypeName Microsoft.SqlServer.Management.Smo.Login `
-ArgumentList $server, $loginName
$login.LoginType = [Microsoft.SqlServer.Management.Smo.LoginType]::SqlLogin
$login.PasswordExpirationEnabled = $false
$login.PasswordPolicyEnforced = $false
$login.Create($password)
Write-Host("Login $loginName created successfully.")

$dbExists = $FALSE
foreach ($db in $server.databases) {
  if ($db.name -eq "$database") {
    Write-Host "$database already exists."
    $dbExists = $TRUE
  }
}

if ($dbExists -eq $FALSE) {
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -Argumentlist $server, $database
  $db.Create()
}

echo "==========================================="
echo "Provision ended."
echo "==========================================="
