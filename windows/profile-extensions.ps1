# Increase history
$MaximumHistoryCount = 10000

# Produce UTF-8 by default
$PSDefaultParameterValues["Out-File:Encoding"]="utf8"

# Show selection menu for tab
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete

# Aliases
#######################################################

del alias:gc -Force
del alias:gp -Force

function gs() { git status }

function ga () { git add $args[0] }

function amend () { git commit --amend --no-edit }

function gc () { git commit }

function gp () { git pull }

function gd() { git diff }

Set-Alias k kubectl

function kdump() {
        kubectl get all --all-namespaces
}