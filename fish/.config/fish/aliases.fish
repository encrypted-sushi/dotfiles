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


function env
    if isatty stdout
        command env $argv | sort | while read -l line
            set -l key (string split -m 1 "=" $line)[1]
            set -l val (string split -m 1 "=" $line)[2]
            
            if set -q val
                # KEY: Blue (89b4fa) - The 'jq' blue
                set_color 89b4fa; echo -n "$key"
                
                # EQUALS: Surface1 (45475a) - Subtle
                set_color 45475a; echo -n "="
                
                # VALUE: Green (a6da95) - The Mocha Green you had earlier
                set_color a6da95; echo "$val"
            else
                echo "$line"
            end
        end
        set_color normal
    else
        command env $argv
    end
end


