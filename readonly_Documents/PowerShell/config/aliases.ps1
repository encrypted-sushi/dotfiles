function Show-ChildItem {
  eza --icons $args
}
# Use "-Force" to override the system alias
Set-Alias -Name ls -Value Show-ChildItem -Force

# Replace the regular "tree" command with output from eza
function Show-Tree {
  eza --icons --tree $args
}
Set-Alias -Name tree -Value Show-Tree -Force 

function shipit {
    Write-Host "📦 Re-adding files to Chezmoi..." -ForegroundColor Cyan
    chezmoi re-add
    
    # Enter the source directory to perform git actions
    Write-Host "🚢 Pushing shipment to GitHub..." -ForegroundColor Green
    chezmoi cd -- pwsh -Command {
        git add .
        $msg = "update: " + (Get-Date -Format 'yyyy-MM-dd HH:mm')
        git commit -m $msg
        git push origin master
    }
    
    Write-Host "✅ Shipment complete! Sleep well." -ForegroundColor Gold
}

