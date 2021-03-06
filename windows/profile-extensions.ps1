# Increase history
$MaximumHistoryCount = 10000

# Produce UTF-8 by default
$PSDefaultParameterValues["Out-File:Encoding"]="utf8"

# Show selection menu for tab
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# Powershell noise
Set-PSReadlineOption -BellStyle None

# Aliases
#######################################################

del alias:gc -Force
del alias:gp -Force

function gs() { git status }

function ga () { git add $args[0] }

function amend () { git commit --amend --no-edit }

function gc () { git commit }

function gp () { git push }

function gr() { git pull --rebase origin $args[0] }

function gri() { git rebase -i origin/$args[0] }

function gd() { git diff }

function gcp() { 
    git commit -a -m $args[0]
    git push
}

function exp() { explorer . }

Set-Alias k kubectl

function kdump() {
        kubectl get all --all-namespaces
}
