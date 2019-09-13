echo "Setting Location to C:\Setup\Scripts"
Set-Location C:\Setup\Scripts
echo "Downloaden ADK"
Start-BitsTransfer -Source "http://download.microsoft.com/download/0/1/C/01CC78AA-B53B-4884-B7EA-74F2878AA79F/adk/adksetup.exe" -Destination "$PSScriptRoot\adksetup.exe"
echo "Installeren ADK"
try {
	Start-Process ".\adksetup.exe" -ArgumentList "/quiet /installpath C:\ADK /features OptionId.DeploymentTools OptionId.UserStateMigrationTool" -Wait
} catch {
	Write-Host "adksetup.exe returned the following error $_"
    Throw "Aborted adksetup.exe returned $_"
}
echo "Downloaden Windows Preinstallation Environment"
Start-BitsTransfer -Source "http://download.microsoft.com/download/D/7/E/D7E22261-D0B3-4ED6-8151-5E002C7F823D/adkwinpeaddons/adkwinpesetup.exe" -Destination "$PSScriptRoot\adkwinpesetup.exe"
echo "Installeren Windows Preinstallation Environment"
try {
	Start-Process ".\adkwinpesetup.exe" -ArgumentList "/quiet /installpath C:\ADK /features OptionId.WindowsPreinstallationEnvironment" -Wait
} catch {
	Write-Host ".\adkwinpesetup.exe returned the following error $_"
    Throw "Aborted .\adkwinpesetup.exe returned $_"
}
echo "Downloaden Microsoft Deployment Toolkit"
Start-BitsTransfer -Source "https://download.microsoft.com/download/3/3/9/339BE62D-B4B8-4956-B58D-73C4685FC492/MicrosoftDeploymentToolkit_x64.msi" -Destination "$PSScriptRoot\MicrosoftDeploymentToolkit_x64.msi"
echo "Installeren Microsoft Deployment Toolkit"
try {
	Start-Process "msiexec.exe" -ArgumentList "/i ""MicrosoftDeploymentToolkit_x64.msi"" /qn" -Wait
} catch {
	Write-Host "msiexec.exe returned the following error $_"
    Throw "Aborted msiexec.exe returned $_"
}
echo "Aanmaken en delen logs folder"
New-Item -Path C:\Logs -ItemType directory
New-SmbShare -Name Logs$ -Path C:\Logs -ChangeAccess EVERYONE
icacls C:\Logs /grant '"MDT_BA":(OI)(CI)(M)'
echo "Aanmaken MDT Deployment Share"
Add-PSSnapIn Microsoft.BDD.PSSnapIn -ErrorAction SilentlyContinue 
New-Item -Path C:\MDTProduction -ItemType directory
New-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "C:\MDTProduction" -Description "MDT Production" -NetworkPath "\\MDTServer\MDTProduction$" | add-MDTPersistentDrive
New-SmbShare -Name MDTProduction$ -Path C:\MDTProduction -ChangeAccess EVERYONE