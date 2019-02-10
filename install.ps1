param (
    [switch]$user = $false,
    [switch]$cleanup = $false,
    [switch]$explorer = $false,
    [switch]$vscode = $false,
    [switch]$dotfiles = $false,
    [switch]$apps = $false,
    [switch]$powershelltheme = $false,
    [switch]$bootstrap = $false,
    [switch]$admin = $false,
    [switch]$autohotkey = $false
)

function disable-services {
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

function remove-bloatware {
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

if ($bootstrap) {
    $boxstarter = $true
    $scoop = $true
}

if($admin){
    $cleanup = $true
    $explorer = $true
    $dotfiles = $true
}

if ($user) {
    $apps = $true
    $powershelltheme = $true
    $vscode = $true
}

if ($cleanup) {
    Write-Host "Running cleanup..."
    remove-bloatware
    disable-services
}

if ($boxstarter) {
    . { Invoke-WebRequest -useb https://boxstarter.org/bootstrapper.ps1 } | Invoke-Expression; get-boxstarter -Force
}

if ($scoop) {
    Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')

    Write-Host "You may need to run: \nSet-ExecutionPolicy RemoteSigned -scope CurrentUser"
}

if ($apps) {
    scoop install git sudo grep curl sed tar touch which vim direnv dotnet-sdk nvm concfg
    scoop bucket add extras
    scoop update
    scoop install autohotkey firefox vscode flux posh-git
}

if ($powershelltheme) {
    concfg import vs-code-dark-plus
}

if ($explorer) {
    Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar

    Disable-BingSearch
    Disable-GameBarTips
    Set-TaskbarOptions -Size Small -Dock Bottom -Combine Full -Lock
    Set-TaskbarOptions -Size Small -Dock Bottom -Combine Full -AlwaysShowIconsOn
}

if ($vscode) {
    Write-Host "Installing vscode extensions..."
    Get-Content .\vscode-extensions.txt | ForEach-Object {code --install-extension $_}
}

if ($dotfiles) {
    Write-Host "Installing dotfiles..."

    New-Item -Path $env:HOME\.gitconfig -ItemType SymbolicLink -Value .\git\.gitconfig -Force

    New-Item -Path $env:APPDATA\Code\User\settings.json -ItemType SymbolicLink -Value .\vscode\settings.json -Force

    New-Item -Path $env:HOME\.vimrc -ItemType SymbolicLink -Value .\vim\.vimrc -Force

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

if ($autohotkey) {
    $STARTUP_DIR = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    New-Item -Path "$STARTUP_DIR\vim.ahk" -ItemType SymbolicLink -Value .\windows\vim.ahk
}
