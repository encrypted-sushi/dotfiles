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
set -gx JQ_COLORS "38;2;108;112;134:38;2;198;160;246:38;2;198;160;246:38;2;125;196;228:38;2;166;227;161:38;2;205;214;244:38;2;205;214;244:38;2;137;180;250"
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
        --colors="highlight:bg:$COM_SURFACE1" \
        $argv
end
# alias rg="command rg \
#     --colors=path:fg:$COM_BLUE \
#     --colors=line:fg:$COM_OVERLAY0 \
#     --colors=column:fg:$COM_OVERLAY2 \
#     --colors=match:fg:$COM_RED \
#     --colors=match:style:bold \
#     --colors=highlight:bg:$COM_SURFACE1" # This fixes the "all white" text issue
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

# ─── TIDE ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── {{{
# ── Prompt frame & structure ─────────────────────────────────────────────────
set -U tide_left_prompt_frame_color      585b70   # Surface2
set -U tide_right_prompt_frame_color     585b70   # Surface2
set -U tide_prompt_color_frame_and_connection 585b70
set -U tide_prompt_color_separator_same_color 45475a  # Surface1

# ── OS ────────────────────────────────────────────────────────────────────────
set -U tide_os_bg_color                  89b4fa   # Blue
set -U tide_os_color                     1e1e2e   # Base
set -U tide_os_icon_bg_color             b4befe   # Lavender

# ── PWD ───────────────────────────────────────────────────────────────────────
set -U tide_pwd_bg_color                 89b4fa   # Blue
set -U tide_pwd_color_anchors            1e1e2e   # Base (bold anchors on blue)
set -U tide_pwd_color_dirs               1e1e2e   # Base
set -U tide_pwd_color_truncated_dirs     313244   # Surface0 (dimmed)

# ── Git ───────────────────────────────────────────────────────────────────────
set -U tide_git_bg_color                 a6e3a1   # Green  (clean)
set -U tide_git_bg_color_unstable        f9e2af   # Yellow (dirty/unstaged)
set -U tide_git_bg_color_urgent          f38ba8   # Red    (conflicted/urgent)
set -U tide_git_color_branch             1e1e2e   # Base
set -U tide_git_color_dirty              1e1e2e   # Base
set -U tide_git_color_staged             1e1e2e   # Base
set -U tide_git_color_untracked          1e1e2e   # Base
set -U tide_git_color_conflicted         1e1e2e   # Base
set -U tide_git_color_operation          1e1e2e   # Base
set -U tide_git_color_stash              1e1e2e   # Base
set -U tide_git_color_upstream           1e1e2e   # Base

# ── Character (prompt symbol) ─────────────────────────────────────────────────
set -U tide_character_color              a6e3a1   # Green  (success)
set -U tide_character_color_failure      f38ba8   # Red    (failure)

# ── Status ────────────────────────────────────────────────────────────────────
set -U tide_status_bg_color              a6e3a1   # Green
set -U tide_status_bg_color_failure      f38ba8   # Red
set -U tide_status_color                 1e1e2e   # Base
set -U tide_status_color_failure         1e1e2e   # Base

# ── Command duration ──────────────────────────────────────────────────────────
set -U tide_cmd_duration_bg_color        f9e2af   # Yellow
set -U tide_cmd_duration_color           1e1e2e   # Base

# ── Context (user@host) ───────────────────────────────────────────────────────
set -U tide_context_bg_color             313244   # Surface0
set -U tide_context_color_default        cdd6f4   # Text
set -U tide_context_color_root           f38ba8   # Red   (root = danger)
set -U tide_context_color_ssh            89dceb   # Sky

# ── Jobs ──────────────────────────────────────────────────────────────────────
set -U tide_jobs_bg_color                313244   # Surface0
set -U tide_jobs_color                   f9e2af   # Yellow

# ── Python ────────────────────────────────────────────────────────────────────
set -U tide_python_bg_color              313244   # Surface0
set -U tide_python_color                 89b4fa   # Blue

# ── Node ──────────────────────────────────────────────────────────────────────
set -U tide_node_bg_color                a6e3a1   # Green
set -U tide_node_color                   1e1e2e   # Base

# ── Bun ───────────────────────────────────────────────────────────────────────
set -U tide_bun_bg_color                 313244   # Surface0
set -U tide_bun_color                    f5e0dc   # Rosewater

# ── Go ────────────────────────────────────────────────────────────────────────
set -U tide_go_bg_color                  89dceb   # Sky
set -U tide_go_color                     1e1e2e   # Base

# ── Rust ──────────────────────────────────────────────────────────────────────
set -U tide_rustc_bg_color               fab387   # Peach
set -U tide_rustc_color                  1e1e2e   # Base

# ── Ruby ──────────────────────────────────────────────────────────────────────
set -U tide_ruby_bg_color                f38ba8   # Red
set -U tide_ruby_color                   1e1e2e   # Base

# ── PHP ───────────────────────────────────────────────────────────────────────
set -U tide_php_bg_color                 cba6f7   # Mauve
set -U tide_php_color                    1e1e2e   # Base

# ── Elixir ────────────────────────────────────────────────────────────────────
set -U tide_elixir_bg_color              cba6f7   # Mauve
set -U tide_elixir_color                 1e1e2e   # Base

# ── Java ──────────────────────────────────────────────────────────────────────
set -U tide_java_bg_color                fab387   # Peach
set -U tide_java_color                   1e1e2e   # Base

# ── Zig ───────────────────────────────────────────────────────────────────────
set -U tide_zig_bg_color                 f9e2af   # Yellow
set -U tide_zig_color                    1e1e2e   # Base

# ── Kubectl ───────────────────────────────────────────────────────────────────
set -U tide_kubectl_bg_color             74c7ec   # Sapphire
set -U tide_kubectl_color                1e1e2e   # Base

# ── Docker ────────────────────────────────────────────────────────────────────
set -U tide_docker_bg_color              89b4fa   # Blue
set -U tide_docker_color                 1e1e2e   # Base

# ── gcloud ────────────────────────────────────────────────────────────────────
set -U tide_gcloud_bg_color              74c7ec   # Sapphire
set -U tide_gcloud_color                 1e1e2e   # Base

# ── AWS ───────────────────────────────────────────────────────────────────────
set -U tide_aws_bg_color                 fab387   # Peach (close to AWS orange)
set -U tide_aws_color                    1e1e2e   # Base

# ── Terraform ─────────────────────────────────────────────────────────────────
set -U tide_terraform_bg_color           cba6f7   # Mauve
set -U tide_terraform_color              1e1e2e   # Base

# ── Pulumi ────────────────────────────────────────────────────────────────────
set -U tide_pulumi_bg_color              f9e2af   # Yellow
set -U tide_pulumi_color                 1e1e2e   # Base

# ── Nix shell ─────────────────────────────────────────────────────────────────
set -U tide_nix_shell_bg_color           89dceb   # Sky
set -U tide_nix_shell_color              1e1e2e   # Base

# ── Direnv ────────────────────────────────────────────────────────────────────
set -U tide_direnv_bg_color              f9e2af   # Yellow
set -U tide_direnv_bg_color_denied       f38ba8   # Red
set -U tide_direnv_color                 1e1e2e   # Base
set -U tide_direnv_color_denied          1e1e2e   # Base

# ── Distrobox ─────────────────────────────────────────────────────────────────
set -U tide_distrobox_bg_color           f5c2e7   # Pink
set -U tide_distrobox_color              1e1e2e   # Base

# ── Toolbox ───────────────────────────────────────────────────────────────────
set -U tide_toolbox_bg_color             cba6f7   # Mauve
set -U tide_toolbox_color                1e1e2e   # Base

# ── Vi mode ───────────────────────────────────────────────────────────────────
set -U tide_vi_mode_bg_color_default     585b70   # Surface2  (normal)
set -U tide_vi_mode_color_default        cdd6f4   # Text
set -U tide_vi_mode_bg_color_insert      a6e3a1   # Green     (insert)
set -U tide_vi_mode_color_insert         1e1e2e   # Base
set -U tide_vi_mode_bg_color_replace     fab387   # Peach     (replace)
set -U tide_vi_mode_color_replace        1e1e2e   # Base
set -U tide_vi_mode_bg_color_visual      cba6f7   # Mauve     (visual)
set -U tide_vi_mode_color_visual         1e1e2e   # Base

# ── Time ──────────────────────────────────────────────────────────────────────
set -U tide_time_bg_color                45475a   # Surface1
set -U tide_time_color                   cdd6f4   # Text

# ── Shlvl ─────────────────────────────────────────────────────────────────────
set -U tide_shlvl_bg_color               f5c2e7   # Pink
set -U tide_shlvl_color                  1e1e2e   # Base

# ── Private mode ──────────────────────────────────────────────────────────────
set -U tide_private_mode_bg_color        585b70   # Surface2
set -U tide_private_mode_color           cdd6f4   # Text

# ── Crystal ───────────────────────────────────────────────────────────────────
set -U tide_crystal_bg_color             94e2d5   # Teal
set -U tide_crystal_color                1e1e2e   # Base

# }}}

# vim: set foldmethod=marker:
