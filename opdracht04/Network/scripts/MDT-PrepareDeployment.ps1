echo "Adding MDT Powershell SnapIn"
Add-PSSnapin -Name Microsoft.BDD.PSSnapIn
echo "Adding Windows 10 Reference Image to MDT Production Share"
New-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "C:\MDTProduction" -Description "MDT Production" -NetworkPath "\\MDTServer\MDTProduction$" | add-MDTPersistentDrive
$winFile = Get-ChildItem $PSScriptRoot -Filter "*.wim" | Select -ExpandProperty FullName
Import-MDTOperatingSystem -Path "DS001:\Operating Systems" -SourceFile $winFile -DestinationFolder "Windows 10" -Verbose
echo "Downloading Adobe Reader"
New-Item -Path "$PSScriptRoot\apps\Adobe Reader" -ItemType Directory -Force
Start-BitsTransfer -Source "http://ardownload.adobe.com/pub/adobe/reader/win/AcrobatDC/1900820071/AcroRdrDC1900820071_nl_NL.exe" -Destination "$PSScriptRoot\apps\Adobe Reader\adobe.exe"
echo "Importing Adobe Reader To MDT"
Import-MDTApplication -Path "DS001:\Applications" -Name "Adobe Reader" -ShortName "Adobe Reader" -Publisher "" -Language "" -Enable "True" -Version  1.0 -Verbose -CommandLine "adobe.exe /sPB /rs" -WorkingDirectory ".\Applications\Adobe Reader" -ApplicationSourcePath "$PSScriptRoot\apps\Adobe Reader" -DestinationFolder "Adobe Reader"
echo "Importing Open Office To MDT"
Import-MDTApplication -Path "DS001:\Applications" -Name "Open Office" -ShortName "Open Office" -Publisher "" -Language "" -Enable "True" -Version  1.0 -Verbose -CommandLine ".\setup.exe /qn" -WorkingDirectory ".\Applications\Open Office" -ApplicationSourcePath "$PSScriptRoot\apps\Open Office" -DestinationFolder "Open Office"
echo "Downloading Java"
New-Item -Path "$PSScriptRoot\apps\Java" -ItemType Directory -Force
Start-BitsTransfer -Source "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=238729_478a62b7d4e34b78b671c754eaaf38ab" -Destination "$PSScriptRoot\apps\Java\java.exe"
echo "Importing Java To MDT"
Import-MDTApplication -Path "DS001:\Applications" -Name "Java" -ShortName "Java" -Publisher "" -Language "" -Enable "True" -Version  1.0 -Verbose -CommandLine "java.exe /s" -WorkingDirectory ".\Applications\Java" -ApplicationSourcePath "$PSScriptRoot\apps\Java" -DestinationFolder "Java"
echo "Adding Deployment Task Sequence"
$os = Get-ChildItem -Path "DS001:\Operating Systems"
$folder = Split-Path -Path $os.Source -Leaf
Import-MDTTaskSequence -Path "DS001:\Task Sequences" -Name "Windows 10 Enterprise x64 RTM Custom Image" -Template "Client.xml" -ID W10-X64-001 -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\$($os.Name)" -FullName "MDTTEST" -OrgName "MDTTEST" -HomePage "about:blank" -Verbose $true
echo "Editing bootstrap.ini"
$bootstrap = @"
[Settings]
Priority=Default
[Default]
DeployRoot=\\MDTServer\MDTProduction$
UserDomain=MDTTEST
UserID=MDT_BA
UserPassword=P@ssw0rd
SkipBDDWelcome=YES
OSDAdapterCount=1
OSDAdapter0EnableDHCP=True
OSDAdapter0DNSServerList=192.168.2.2,10.0.2.15
OSDAdapter0Name=intnet
"@
sc -Path "C:\MDTProduction\Control\Bootstrap.ini" -Value $bootstrap -Force -Confirm:$False
echo "Editing Rules"
$rules = @"
[Settings]
Priority=Default
[Default]
_SMSTSORGNAME=MDTTEST
OSInstall=YES
UserDataLocation=AUTO
TimeZoneName=Pacific Standard Time 
AdminPassword=P@ssw0rd
JoinDomain=mdttest.com
DomainAdmin=MDT_JD
DomainAdminPassword=P@ssw0rd
SLShare=\\MDTServer\Logs$
ScanStateArgs=/ue:*\* /ui:MDTTEST\*
USMTMigFiles001=MigApp.xml
USMTMigFiles002=MigUser.xml
HideShell=YES
ApplyGPOPack=NO
SkipAppsOnUpgrade=NO
SkipAdminPassword=YES
SkipProductKey=YES
SkipComputerName=NO
SkipDomainMembership=YES
SkipUserData=YES
SkipLocaleSelection=YES
SkipTaskSequence=NO
SkipTimeZone=YES
SkipApplications=NO
SkipBitLocker=YES
SkipSummary=YES
SkipCapture=YES
SkipFinalSummary=NO
EventService=http://MDTServer:9800
"@
sc -Path "C:\MDTProduction\Control\CustomSettings.ini" -Value $rules -Force -Confirm:$False
echo "Editing Settings"
$settingsFile = "C:\MDTProduction\Control\Settings.xml"
$xml = [XML](Get-Content $settingsFile)
$xml.Settings."Boot.x86.LiteTouchWIMDescription" = "MDT Production x86"
$xml.Settings."Boot.x86.LiteTouchISOName" = "MDT Production x86.iso"
$xml.Settings."Boot.x64.LiteTouchWIMDescription" = "MDT Production x64"
$xml.Settings."Boot.x64.LiteTouchISOName" = "MDT Production x64.iso"
$xml.Settings."Boot.x86.FeaturePacks" = ""
$xml.Settings."Boot.x64.FeaturePacks" = ""
$xml.Settings.MonitorHost = "MDTServer"
$xml.Settings.MonitorEventPort = "9800"
$xml.Settings.MonitorDataPort = "9801"
$xml.Save($settingsFile)
echo "Enabling Windows Update in Task Sequence"
$ts = Get-ChildItem C:\MDTProduction\Control -Recurse | Where-Object {$_.Name -match "ts.xml"}
$folder = (Get-Item $ts.FullName).Directory.FullName
$lines = @()
Foreach ($line in (Get-Content $ts.FullName)){$lines += $line}
$preWU = (Get-Content $ts.FullName) |  Select-String -SimpleMatch -List "Windows Update (Pre-Application Installation)"
$postWU = (Get-Content $ts.FullName) |  Select-String -SimpleMatch -List "Windows Update (Post-Application Installation)"
$preWUindex = $lines.IndexOf($preWU)
$postWUindex = $lines.IndexOf($postWU)
$fixedfile = @()
$fixedfile += $lines[0..($preWUindex - 1)]
$fixedfile += $lines[$preWUindex] -replace 'disable="true"','disable="false"'
$fixedfile += $lines[($preWUindex + 1)..($postWUindex - 1)]
$fixedfile += $lines[$postWUindex] -replace 'disable="true"','disable="false"'
$fixedfile += $lines[($postWUindex + 1)..($lines.Count -1)]
$fixedfile > $folder\ts.xml
echo "Updating MDT Production Share"
Update-MDTDeploymentShare -Path "DS001:" -Force -Verbose
echo "Installing WDS"
Add-WindowsFeature -Name WDS -IncludeAllSubFeature -IncludeManagementTools
wdsutil /initialize-server /remInst:"C:\remInstall" /standalone
wdsutil /Set-Server /AnswerClients:All
echo "Adding Boot Image to WDS"
Import-WdsBootImage -Path "C:\MDTProduction\Boot\LiteTouchPE_x64.wim" -SkipVerify -NewImageName "MDT Production x64"