Clear-Host

$env:SSH_AUTH_SOCK = $null

# Define my path to $PROFILE
$profilePath = Split-Path $PROFILE

# Define my config path
$configPath = Join-Path $profilePath "configs"
if (Test-Path $configPath) {
  Get-ChildItem -Path $configPath -Filter *.ps1 | ForEach-Object {
    . $_.FullName
  }
}

# Ctrl+U - delete to beginning of line
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardKillLine

# Ctrl+K - delete to end of line
Set-PSReadLineKeyHandler -Key Ctrl+k -Function KillLine

# Ctrl+W - delete word backwards
Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardKillWord

# Ctrl+A - beginning of line (already default, but just in case)
Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine

# Ctrl+E - end of line (already default)
Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine

Set-PSReadLineKeyHandler -Key Ctrl+z -ScriptBlock {
    # Test-Suspend (tsus) is a reliable method to suspend the foreground process.
    tsus
}

 function ls_eza {
    # Call eza, always including --icons, 
    # and then passing any additional arguments the user typed ($args)
    eza --icons $args
}   
Set-Alias -Name ls -Value ls_eza -Force
