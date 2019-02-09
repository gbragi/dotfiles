# To Run
#
# Install Chocolatey
# Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#
# Install BoxStarter
# cinst boxstarter
#
# Install-BoxstarterPackage -PackageName C:\code\dotfiles\windows\boxstarter.ps1

# Configure Windows
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar

Update-ExecutionPolicy Unrestricted

Disable-BingSearch
Disable-GameBarTips

Set-TaskbarOptions -Size Small -Dock Bottom -Combine Full -Lock
Set-TaskbarOptions -Size Small -Dock Bottom -Combine Full -AlwaysShowIconsOn

# cinst -y Microsoft-Hyper-V-All -source windowsFeatures
# cinst -y Microsoft-Windows-Subsystem-Linux -source windowsfeatures

# Packages
# cinst -y hyper
cinst -y f.lux

## Git
cinst -y git.install
cinst -y poshgit

# Restart PowerShell / CMDer before moving on - or run
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

cinst Git-Credential-Manager-for-Windows
# cinst github-desktop

## Node, npm
cinst -y nodejs.install

## Editors
cinst -y vscode

## Visual Studio 2017
# cinst -y visualstudio2017community
if (Test-PendingReboot) { Invoke-Reboot }

## Ruby, Go, Python
cinst dotnetcore-sdk 
cinst golang
cinst -y python
cinst -y pip

if (Test-PendingReboot) { Invoke-Reboot }

## Devops

# cinst azure-cli

# cinst awscli
# cinst awstools.powershell

cinst docker-for-windows
# comes with docker-for-windows
# cinst kubernetes-cli
if (Test-PendingReboot) { Invoke-Reboot }

## Basics
# cinst -y 7zip.install
# cinst firefox
# cinst -y sysinternals
# cinst -y DotNet3.5

# cinst -y DotNet4.0 -- not needed on windows 8
# cinst -y DotNet4.5 -- not needed on windows 10
# cinst -y PowerShell -- not needed on windows 10

if (Test-PendingReboot) { Invoke-Reboot }

# Get Updates
Install-WindowsUpdate -acceptEula

if (Test-PendingReboot) { Invoke-Reboot }
