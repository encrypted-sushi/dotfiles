# catppuccin-mocha-colors.fish
# This is a personal collection of trying to make a lot of my tools to use 
# the Catppuccin Mocha colors

# ─────────────────────────────────────────────────────────────────────────────
# ACCENTS (The Colors)
# ─────────────────────────────────────────────────────────────────────────────
# Name        Hex        Semicolon (38;2;R;G;B)  Comma (R,G,B)
set -g ROSEWATER "#f5e0dc"; set -g RGB_ROSEWATER "245;224;220"; set -g COM_ROSEWATER "245,224,220"
set -g FLAMINGO  "#f2cdcd"; set -g RGB_FLAMINGO  "242;205;205"; set -g COM_FLAMINGO  "242,205,205"
set -g PINK      "#f5c2e7"; set -g RGB_PINK      "245;194;231"; set -g COM_PINK      "245,194,231"
set -g MAUVE     "#cba6f7"; set -g RGB_MAUVE     "198;160;246"; set -g COM_MAUVE     "198,160,246"
set -g RED       "#f38ba8"; set -g RGB_RED       "243;139;168"; set -g COM_RED       "243,139,168"
set -g MAROON    "#eba0ac"; set -g RGB_MAROON    "235;160;172"; set -g COM_MAROON    "235,160,172"
set -g PEACH     "#fab387"; set -g RGB_PEACH     "250;179;135"; set -g COM_PEACH     "250,179,135"
set -g YELLOW    "#f9e2af"; set -g RGB_YELLOW    "249;226;175"; set -g COM_YELLOW    "249,226,175"
set -g GREEN     "#a6e22e"; set -g RGB_GREEN     "166;227;161"; set -g COM_GREEN     "166,227,161"
set -g TEAL      "#94e2d5"; set -g RGB_TEAL      "148;226;213"; set -g COM_TEAL      "148,226,213"
set -g SKY       "#89dceb"; set -g RGB_SKY       "137;220;235"; set -g COM_SKY       "137,220;235"
set -g SAPPHIRE  "#74c7ec"; set -g RGB_SAPPHIRE  "116;199;236"; set -g COM_SAPPHIRE  "116,199,236"
set -g BLUE      "#89b4fa"; set -g RGB_BLUE      "137;180;250"; set -g COM_BLUE      "137,180,250"
set -g LAVENDER  "#b4befe"; set -g RGB_LAVENDER  "180;190;254"; set -g COM_LAVENDER  "180,190,254"

# ─────────────────────────────────────────────────────────────────────────────
# MONO / SURFACES (The UI Foundation)
# ─────────────────────────────────────────────────────────────────────────────
set -g TEXT      "#cdd6f4"; set -g RGB_TEXT      "205;214;244"; set -g COM_TEXT      "205,214,244"
set -g SUBTEXT1  "#bac2de"; set -g RGB_SUBTEXT1  "186;194;222"; set -g COM_SUBTEXT1  "186,194,222"
set -g SUBTEXT0  "#a6adc8"; set -g RGB_SUBTEXT0  "166;173;200"; set -g COM_SUBTEXT0  "166,173,200"
set -g OVERLAY2  "#9399b2"; set -g RGB_OVERLAY2  "147;153;178"; set -g COM_OVERLAY2  "147,153,178"
set -g OVERLAY1  "#7f849c"; set -g RGB_OVERLAY1  "127;132;156"; set -g COM_OVERLAY1  "127,132,156"
set -g OVERLAY0  "#6c7086"; set -g RGB_OVERLAY0  "108;112;134"; set -g COM_OVERLAY0  "108,112,134"
set -g SURFACE2  "#585b70"; set -g RGB_SURFACE2  "88;91;112";   set -g COM_SURFACE2  "88,91,112"
set -g SURFACE1  "#45475a"; set -g RGB_SURFACE1  "69;71;90";    set -g COM_SURFACE1  "69,71,90"
set -g SURFACE0  "#313244"; set -g RGB_SURFACE0  "49;50;68";    set -g COM_SURFACE0  "49,50,68"
set -g BASE      "#1e1e2e"; set -g RGB_BASE      "30;30;46";    set -g COM_BASE      "30,30,46"
set -g MANTLE    "#181825"; set -g RGB_MANTLE    "24;24;37";    set -g COM_MANTLE    "24,24,37"
set -g CRUST     "#11111b"; set -g RGB_CRUST     "17;17;27";    set -g COM_CRUST     "17,17,27"


# ─── FISH THEME ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── {{{
fish_config theme choose catppuccin-mocha --color-theme=dark
# }}}

# ─── JQ COLORS ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── {{{
#                 |      null      |     false      |      true      |    numbers     |    strings     |     arrays     |    objects     |      keys      |
set -gx JQ_COLORS "38;2;137;180;250:38;2;250;179;135:38;2;250;179;135:38;2;125;196;228:38;2;166;227;161:38;2;205;214;244:38;2;205;214;244:38;2;137;220;235"
# }}}

# ─── RIPGREP ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── {{{
function rg
    command rg \
        --heading \
        --line-number \
        --smart-case \
        --sort-files \
        --colors="path:fg:$COM_BLUE" \
        --colors="path:style:bold" \
        --colors="line:fg:$COM_OVERLAY0" \
        --colors="column:fg:$COM_OVERLAY2" \
        --colors="match:fg:$COM_RED" \
        --colors="match:style:bold" \
        --colors="match:bg:$COM_SURFACE0" \
        --colors="context:fg:$COM_TEXT" \
        $argv
end
# alias rg="command rg \
#     --colors=path:fg:$COM_BLUE \
#     --colors=line:fg:$COM_OVERLAY0 \
#     --colors=column:fg:$COM_OVERLAY2 \
#     --colors=match:fg:$COM_RED \
#     --colors=match:style:bold \
#     --colors=context:fg:$COM_TEXT" # This fixes the "all white" text issue
# }}}

# ─── BAT ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── {{{
set -gx BAT_THEME "Catppuccin-mocha"
# bat cache --build if applying the first time
# }}}

# ─── FZF ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── {{{
set -gx FZF_DEFAULT_OPTS " \
    --color=bg+:$SURFACE0,bg:$BASE,spinner:$ROSEWATER,hl:$RED \
    --color=fg:$TEXT,header:$RED,info:$MAUVE,pointer:$ROSEWATER \
    --color=marker:$ROSEWATER,fg+:$TEXT,prompt:$MAUVE,hl+:$RED \
    --height=80% \
    --layout=reverse \
    --border \
    --margin=1 \
    --padding=1 \
    --preview 'bat --color=always --style=numbers --line-range :500 {}'"
# }}}
# vim: set foldmethod=marker:
