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
