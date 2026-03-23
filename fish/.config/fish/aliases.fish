if type -q eza
    alias ls='eza --icons=always --color-scale=all'
else
    # Check if the installed ls supports color (handling BusyBox vs GNU)
    if ls --color=auto >/dev/null 2>&1
        alias ls='ls --color=auto'
    else
        alias ls='ls -G' # macOS/BSD fallback
    end
end

