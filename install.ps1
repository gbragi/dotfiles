param (
    [switch]$all = $false,
    [switch]$choco = $false,
    [switch]$boxstarter = $false,
    [switch]$cleanup = $false,
    [switch]$vscode = $false,
    [switch]$dotfiles = $false
)

function choco {
    Write-Host "Installing chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function boxstarter {
    Write-Host "Installing boxstarter..."
    cinst boxstarter
    Import-Module Boxstarter.Chocolatey
    $boxstarter_dir = (Get-Item -Path ".\").FullName
    Install-BoxstarterPackage -PackageName $boxstarter_dir\windows\boxstarter.ps1
}

function cleanup {
    Write-Host "Running cleanup..."
    .\windows\cleanup\remove-bloatware.ps1
    .\windows\cleanup\disable-services.ps1
}

function vscode {
    Write-Host "Installing vscode extensions..."
    Get-Content .\vscode-extensions.txt | ForEach-Object {code --install-extension $_}
}

function dotfiles {
    Write-Host "Installing dotfiles..."

    New-Item -Path $env:HOME\.gitconfig -ItemType SymbolicLink -Value .\windows\.gitconfig -Force

    New-Item -Path $env:APPDATA\Code\User\settings.json -ItemType SymbolicLink -Value .\vscode\settings.json -Force

    New-Item -Path $env:HOME\.vimrc -ItemType SymbolicLink -Value .\vim\.vimrc -Force

    $PROFILE_DIR = (Get-Item $PROFILE).Directory.FullName
    New-Item -Path C:\Users\bragi\Documents\WindowsPowerShell\profile-extensions.ps1 -ItemType SymbolicLink -Value .\windows\profile-extensions.ps1 -Force


    if (Select-String -Path $PROFILE -Pattern "profile-extensions.ps1") {
        Write-Host "profile-extensions already added - skipping"
    }
    else {
        Write-Host "adding profile extensions"
        ". $PROFILE_DIR\profile-extensions.ps1" | Out-File $PROFILE -Append
    }
}


if ($choco) {
    choco
}

if ($boxstarter) {
    boxstarter
}

if ($cleanup) {
   cleanup
}

if ($vscode) {
    vscode
}

if ($dotfiles){
    dotfiles
}

if($all){
    choco
    boxstarter
    cleanup
    vscode
    dotfiles
}