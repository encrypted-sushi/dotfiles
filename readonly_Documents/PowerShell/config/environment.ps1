# XDG_CONFIG_HOME should be set via the GUI, but uncomment the below if not
# $env:XDG_CONFIG_HOME = "$HOME\.config"
$env:RIPGREP_CONFIG_PATH = "$env:XDG_CONFIG_HOME\ripgrep\.ripgreprc"
$env:FZF_DEFAULT_COMMAND = @(
  'fd --type f --hidden --follow',
  '--exclude NTUSER**',
  '--exclude ntuser**',
  '--exclude AppData',
  '--exclude scoop',
  '--exclude .git',
  '--exclude .venv',
  '--exclude .vscode',
  '--exclude node_modules',
  '--exclude cache',
  '--exclude Apps',
  '--exclude fonts',
  '--exclude "__Folders Shared with me__"'
) -join ' '
