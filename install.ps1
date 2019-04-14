function Disable-Services {
    # This script disables unwanted Windows services. If you do not want to disable
    # certain services comment out the corresponding lines below.

    $services = @(
        "diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
        "DiagTrack"                                # Diagnostics Tracking Service
        "dmwappushservice"                         # WAP Push Message Routing Service (see known issues)
        # "HomeGroupListener"                        # HomeGroup Listener
        # "HomeGroupProvider"                        # HomeGroup Provider
        "lfsvc"                                    # Geolocation Service
        "MapsBroker"                               # Downloaded Maps Manager
        "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
        "RemoteAccess"                             # Routing and Remote Access
        "RemoteRegistry"                           # Remote Registry
        "SharedAccess"                             # Internet Connection Sharing (ICS)
        "TrkWks"                                   # Distributed Link Tracking Client
        "WbioSrvc"                                 # Windows Biometric Service
        #"WlanSvc"                                 # WLAN AutoConfig
        "WMPNetworkSvc"                            # Windows Media Player Network Sharing Service
        # "wscsvc"                                   # Windows Security Center Service
        #"WSearch"                                 # Windows Search
        "XblAuthManager"                           # Xbox Live Auth Manager
        "XblGameSave"                              # Xbox Live Game Save Service
        "XboxNetApiSvc"                            # Xbox Live Networking Service

        # Services which cannot be disabled
        #"WdNisSvc"
    )

    foreach ($service in $services) {
        Write-Output "Trying to disable $service"
        Get-Service -Name $service | Set-Service -StartupType Disabled
    }
}

function Remove-Bloatware {
    $apps = @(
        # default Windows 10 apps
        "Microsoft.3DBuilder"
        "Microsoft.Appconnector"
        #"Microsoft.Advertising.Xaml" 
        "Microsoft.BingFinance"
        "Microsoft.BingNews"
        "Microsoft.BingSports"
        "Microsoft.BingTranslator"
        "Microsoft.BingWeather"
        "Microsoft.FreshPaint"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftOfficeHub"
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.MicrosoftPowerBIForWindows"
        "Microsoft.MinecraftUWP"
        "Microsoft.MicrosoftStickyNotes"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.Office.OneNote"
        "Microsoft.OneConnect"
        "Microsoft.People"
        "Microsoft.Print3D"
        "Microsoft.SkypeApp"
        "Microsoft.Wallet"
        #"Microsoft.Windows.Photos"
        "Microsoft.WindowsAlarms"
        #"Microsoft.WindowsCalculator"
        "Microsoft.WindowsCamera"
        "microsoft.windowscommunicationsapps"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowsPhone"
        "Microsoft.WindowsSoundRecorder"
        #"Microsoft.WindowsStore"
        "Microsoft.XboxApp"
        "Microsoft.XboxGameOverlay"
        "Microsoft.XboxGamingOverlay"
        "Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.Xbox.TCUI"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"
    
    
        # Threshold 2 apps
        "Microsoft.CommsPhone"
        "Microsoft.ConnectivityStore"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
        "Microsoft.Office.Sway"
        "Microsoft.OneConnect"
        "Microsoft.WindowsFeedbackHub"

        # Creators Update apps
        "Microsoft.Microsoft3DViewer"
        #"Microsoft.MSPaint"

        #Redstone apps
        "Microsoft.BingFoodAndDrink"
        "Microsoft.BingTravel"
        "Microsoft.BingHealthAndFitness"
        "Microsoft.WindowsReadingList"

        # Redstone 5 apps
        "Microsoft.MixedReality.Portal"
        "Microsoft.ScreenSketch"
        "Microsoft.XboxGamingOverlay"
        "Microsoft.YourPhone"

        # non-Microsoft
        "9E2F88E3.Twitter"
        "PandoraMediaInc.29680B314EFC2"
        "Flipboard.Flipboard"
        "ShazamEntertainmentLtd.Shazam"
        "king.com.CandyCrushSaga"
        "king.com.CandyCrushSodaSaga"
        "king.com.BubbleWitch3Saga"
        "king.com.*"
        "ClearChannelRadioDigital.iHeartRadio"
        "4DF9E0F8.Netflix"
        "6Wunderkinder.Wunderlist"
        "Drawboard.DrawboardPDF"
        "2FE3CB00.PicsArt-PhotoStudio"
        "D52A8D61.FarmVille2CountryEscape"
        "TuneIn.TuneInRadio"
        "GAMELOFTSA.Asphalt8Airborne"
        "TheNewYorkTimes.NYTCrossword"
        "DB6EA5DB.CyberLinkMediaSuiteEssentials"
        "Facebook.Facebook"
        "flaregamesGmbH.RoyalRevolt2"
        "Playtika.CaesarsSlotsFreeCasino"
        "A278AB0D.MarchofEmpires"
        "KeeperSecurityInc.Keeper"
        "ThumbmunkeysLtd.PhototasticCollage"
        "XINGAG.XING"
        "89006A2E.AutodeskSketchBook"
        "D5EA27B7.Duolingo-LearnLanguagesforFree"
        "46928bounde.EclipseManager"
        "ActiproSoftwareLLC.562882FEEB491" # next one is for the Code Writer from Actipro Software LLC
        "DolbyLaboratories.DolbyAccess"
        "SpotifyAB.SpotifyMusic"
        "A278AB0D.DisneyMagicKingdoms"
        "WinZipComputing.WinZipUniversal"
        "CAF9E577.Plex"  
        "7EE7776C.LinkedInforWindows"
        "613EBCEA.PolarrPhotoEditorAcademicEdition"
        "Fitbit.FitbitCoach"
        "DolbyLaboratories.DolbyAccess"
        "Microsoft.BingNews"
        "NORDCURRENT.COOKINGFEVER"

    
        # Additional packages
        "*Dropbox*"
        "*Facebook*"
        "*Dell*"
        "Microsoft.GetStarted"
        "*Keeper*"


        # apps which cannot be removed using Remove-AppxPackage
        #"Microsoft.BioEnrollment"
        #"Microsoft.MicrosoftEdge"
        #"Microsoft.Windows.Cortana"
        #"Microsoft.WindowsFeedback"
        #"Microsoft.XboxGameCallableUI"
        #"Microsoft.XboxIdentityProvider"
        #"Windows.ContactSupport"
    )

    foreach ($app in $apps) {
        Write-Output "Trying to remove $app"

        Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers

        Get-AppXProvisionedPackage -Online |
            Where-Object DisplayName -EQ $app |
            Remove-AppxProvisionedPackage -Online
    }

    $onedrive_setupfile = "C:\Windows\SysWOW64\OneDriveSetup.exe"
    if (Test-Path -Path $onedrive_setupfile) {
        & $onedrive_setupfile /uninstall
    }
}

function Install-Apps {
    $SCOOP_PATH = "$HOME\scoop\shims\scoop"
    if (Test-Path $SCOOP_PATH) {
        Write-Host "Scoop already installed at $SCOOP_PATH"
        scoop update
    }
    else {
        Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
    }

    scoop install git sudo grep curl sed tar unzip touch which vim direnv dotnet-sdk nodejs-lts concfg go

    dotnet tool install -g dotnet-format

    $installExtra = Read-Host 'Do you want to install extra apps? [Y / N (default)]'
    if ($installExtra -eq "Y") {
        scoop bucket add extras
        scoop update
        scoop install posh-git flux
        Add-PoshGitToProfile

        Start-Process https://www.mozilla.org/en-US/firefox/new/
        Start-Sleep -s 1
        # Start-Process https://github.com/dahlbyk/posh-git#installation
        # Start-Process https://justgetflux.com/
        Start-Process https://visualstudio.microsoft.com/
        # Start-Process https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe
    }
    else {
        Write-Host "Skipping extra apps"
    }
}

function Install-PowershellTheme {
    concfg import vs-code-dark-plus
}

function Optimize-Explorer {
    Write-Host "Starting Explorer Optimizations..."

    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    $advancedKey = "$key\Advanced"
    $cabinetStateKey = "$key\CabinetState"
    Set-ItemProperty $advancedKey Hidden 1
    Set-ItemProperty $advancedKey HideFileExt 0
    Set-ItemProperty $advancedKey ShowSuperHidden 0
    Set-ItemProperty $cabinetStateKey FullPath 1

    $path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"

    if (!(Test-Path $path)) {
        New-Item $path
    }

    New-ItemProperty -LiteralPath $path -Name "BingSearchEnabled" -Value 0 -PropertyType "DWord" -ErrorAction SilentlyContinue
    Set-ItemProperty -LiteralPath $path -Name "BingSearchEnabled" -Value 0

    Write-Host "Bing search has been disabled."

    $path = "HKCU:\SOFTWARE\Microsoft\GameBar"
    if (!(Test-Path $path)) {
        New-Item $path
    }

    New-ItemProperty -LiteralPath $path -Name "ShowStartupPanel" -Value 0 -PropertyType "DWord" -ErrorAction SilentlyContinue
    Set-ItemProperty -LiteralPath $path -Name "ShowStartupPanel" -Value 0

    Write-Host "GameBar Tips have been disabled."
}

function Optimize-Dock {
    Write-Host "Starting Explorer Optimizations..."

    $explorerKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $settingKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects2'
    if (-not (Test-Path -Path $settingKey)) {
        $settingKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
    }

    if (Test-Path -Path $key) {
        Set-ItemProperty $key TaskbarSizeMove 0 # Lock the taskbar - set to 1 to unlock
        Set-ItemProperty $key TaskbarSmallIcons 1 # Small taskbar icons - set to 0 for normal size
        Set-ItemProperty $key TaskbarGlomLevel 1 # Change taskbar icon combination style - 0 Always, 1 Full, 2 Never
    }

    if (Test-Path -Path $settingKey) {
        $settings = (Get-ItemProperty -Path $settingKey -Name Settings).Settings
        $settings[12] = 0x03 # Dock to bottom - 0x00 Left, 0x01 Top, 0x02 Right, 0x03 Bottom
        Set-ItemProperty -Path $settingKey -Name Settings -Value $settings
    }

    if (Test-Path -Path $explorerKey) {
        Set-ItemProperty -Path $explorerKey -Name 'EnableAutoTray' -Value 0 # Always show icons in the notification area - set 1 to combine under arrow 
    }

    Write-Host "Dock Optimizations Finished..."
}

function Install-VsCodeExtensions {
    if (Get-Command code -errorAction SilentlyContinue) {
        Write-Host "Installing vscode extensions..."
        Get-Content .\vscode-extensions.txt | ForEach-Object {code --install-extension $_}
    }
    else {
        Write-Host "VsCode has not been installed yet. Install it and re-run 'Install-VsCodeExtensions'"
    }
}

function Install-Dotfiles {
    Write-Host "Installing dotfiles..."

    New-Item -Path "$HOME\.gitconfig" -ItemType SymbolicLink -Value .\git\.gitconfig -Force

    New-Item -Path $env:APPDATA\Code\User\settings.json -ItemType SymbolicLink -Value .\vscode\settings.json -Force

    New-Item -Path "$HOME\_vimrc" -ItemType SymbolicLink -Value .\vim\.vimrc -Force

    New-Item -Path $PROFILE -ItemType File -Force
    $PROFILE_DIR = (Get-Item $PROFILE).Directory.FullName
    New-Item -Path "$PROFILE_DIR\profile-extensions.ps1" -ItemType SymbolicLink -Value .\windows\profile-extensions.ps1 -Force

    if (Select-String -Path $PROFILE -Pattern "profile-extensions.ps1") {
        Write-Host "profile-extensions already added - skipping"
    }
    else {
        Write-Host "adding profile extensions"
        Add-Content -Path $PROFILE -Value ". $PROFILE_DIR\profile-extensions.ps1"
    }
}

function Install-AutoHotkey {
    $STARTUP_DIR = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    New-Item -Path "$STARTUP_DIR\vim.ahk" -ItemType SymbolicLink -Value .\windows\vim.ahk

    Start-Process https://www.autohotkey.com/download/
}

function Install-GitToDotfilesRepo {
    if (Test-Path -Path ".git") {
        Write-Host "Git repo already initialized"
    }
    else {
        mkdir .git
        git clone https://github.com/gbragi/dotfiles .git
        git pull
        git reset head
    }
}

function Remove-MediaDirs {
    Write-Host "removing media directories from home directory"
    Remove-Dir $HOME\Contacts
    Remove-Dir $HOME\Videos
    Remove-Dir $HOME\Music
    Remove-Dir $HOME\Searches
    Remove-Dir $HOME\Links
    Remove-Dir $HOME\OneDrive
    Remove-Dir $HOME\Pictures
    Remove-Dir "$HOME\Saved Games"
    Remove-Dir $HOME\Favorites
    Remove-Dir "$HOME\3D Objects"
}

function Remove-Dir {
    Remove-Item $args[0] -Recurse -Force -ErrorAction Ignore
}

function Start-EnvironmentBootstrap {
    Remove-Bloatware
    Disable-Services
    Optimize-Explorer
    Optimize-Dock
    Install-Dotfiles
}

function Start-EnvironmentConfig {
    Install-Apps
    Install-PowershellTheme
    Install-VsCodeExtensions
}
