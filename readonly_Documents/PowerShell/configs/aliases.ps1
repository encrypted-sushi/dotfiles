# Replace the regular "tree" command with output from eza
function Show-Tree {
  eza --icons --tree $args
}
Set-Alias -Force -Name tree -Value Show-Tree
