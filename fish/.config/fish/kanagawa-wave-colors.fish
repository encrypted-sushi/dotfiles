# kanagawa-wave-colors.fish
# Terminal tooling theme for Kanagawa Wave
# Palette sourced directly from rebelot/kanagawa.nvim colors.lua
# Structure mirrors catppuccin-mocha-colors.fish

# ─────────────────────────────────────────────────────────────────────────────
# PALETTE — WAVE ACCENTS
# ─────────────────────────────────────────────────────────────────────────────
# Name                Hex        Semicolon (38;2;R;G;B)    Comma (R,G,B)
set -g FUJI_WHITE    "#DCD7BA"; set -g RGB_FUJI_WHITE    "220;215;186"; set -g COM_FUJI_WHITE    "220,215,186"
set -g OLD_WHITE     "#C8C093"; set -g RGB_OLD_WHITE     "200;192;147"; set -g COM_OLD_WHITE     "200,192,147"
set -g FUJI_GRAY     "#727169"; set -g RGB_FUJI_GRAY     "114;113;105"; set -g COM_FUJI_GRAY     "114,113,105"
set -g ONI_VIOLET    "#957FB8"; set -g RGB_ONI_VIOLET    "149;127;184"; set -g COM_ONI_VIOLET    "149,127,184"
set -g ONI_VIOLET2   "#B8B4D0"; set -g RGB_ONI_VIOLET2   "184;180;208"; set -g COM_ONI_VIOLET2   "184,180,208"
set -g CRYSTAL_BLUE  "#7E9CD8"; set -g RGB_CRYSTAL_BLUE  "126;156;216"; set -g COM_CRYSTAL_BLUE  "126,156,216"
set -g SPRING_VIOLET "#9CABCA"; set -g RGB_SPRING_VIOLET "156;171;202"; set -g COM_SPRING_VIOLET "156,171,202"
set -g SPRING_BLUE   "#7FB4CA"; set -g RGB_SPRING_BLUE   "127;180;202"; set -g COM_SPRING_BLUE   "127,180,202"
set -g WAVE_AQUA     "#7AA89F"; set -g RGB_WAVE_AQUA     "122;168;159"; set -g COM_WAVE_AQUA     "122,168,159"
set -g SPRING_GREEN  "#98BB6C"; set -g RGB_SPRING_GREEN  "152;187;108"; set -g COM_SPRING_GREEN  "152,187,108"
set -g BOAT_YELLOW   "#C0A36E"; set -g RGB_BOAT_YELLOW   "192;163;110"; set -g COM_BOAT_YELLOW   "192,163,110"
set -g CARP_YELLOW   "#E6C384"; set -g RGB_CARP_YELLOW   "230;195;132"; set -g COM_CARP_YELLOW   "230,195,132"
set -g SAKURA_PINK   "#D27E99"; set -g RGB_SAKURA_PINK   "210;126;153"; set -g COM_SAKURA_PINK   "210,126,153"
set -g WAVE_RED      "#E46876"; set -g RGB_WAVE_RED      "228;104;118"; set -g COM_WAVE_RED      "228,104,118"
set -g PEACH_RED     "#FF5D62"; set -g RGB_PEACH_RED     "255;93;98";   set -g COM_PEACH_RED     "255,93,98"
set -g SURIMI_ORANGE "#FFA066"; set -g RGB_SURIMI_ORANGE "255;160;102"; set -g COM_SURIMI_ORANGE "255,160,102"

# ─────────────────────────────────────────────────────────────────────────────
# PALETTE — WAVE BACKGROUNDS / UI
# ─────────────────────────────────────────────────────────────────────────────
set -g SUMI_INK0     "#16161D"; set -g RGB_SUMI_INK0     "22;22;29";    set -g COM_SUMI_INK0     "22,22,29"
set -g SUMI_INK1     "#181820"; set -g RGB_SUMI_INK1     "24;24;32";    set -g COM_SUMI_INK1     "24,24,32"
set -g SUMI_INK2     "#1A1A22"; set -g RGB_SUMI_INK2     "26;26;34";    set -g COM_SUMI_INK2     "26,26,34"
set -g SUMI_INK3     "#1F1F28"; set -g RGB_SUMI_INK3     "31;31;40";    set -g COM_SUMI_INK3     "31,31,40"  # main bg
set -g SUMI_INK4     "#2A2A37"; set -g RGB_SUMI_INK4     "42;42;55";    set -g COM_SUMI_INK4     "42,42,55"
set -g SUMI_INK5     "#363646"; set -g RGB_SUMI_INK5     "54;54;70";    set -g COM_SUMI_INK5     "54,54,70"
set -g SUMI_INK6     "#54546D"; set -g RGB_SUMI_INK6     "84;84;109";   set -g COM_SUMI_INK6     "84,84,109" # fg comments
set -g WAVE_BLUE1    "#223249"; set -g RGB_WAVE_BLUE1    "34;50;73";    set -g COM_WAVE_BLUE1    "34,50,73"  # popup bg
set -g WAVE_BLUE2    "#2D4F67"; set -g RGB_WAVE_BLUE2    "45;79;103";   set -g COM_WAVE_BLUE2    "45,79,103" # popup sel

# ─────────────────────────────────────────────────────────────────────────────
# PALETTE — DIFF / DIAG
# ─────────────────────────────────────────────────────────────────────────────
set -g AUTUMN_GREEN  "#76946A"; set -g RGB_AUTUMN_GREEN  "118;148;106"; set -g COM_AUTUMN_GREEN  "118,148,106"
set -g AUTUMN_RED    "#C34043"; set -g RGB_AUTUMN_RED    "195;64;67";   set -g COM_AUTUMN_RED    "195,64,67"
set -g AUTUMN_YELLOW "#DCA561"; set -g RGB_AUTUMN_YELLOW "220;165;97";  set -g COM_AUTUMN_YELLOW "220,165,97"
set -g SAMURAI_RED   "#E82424"; set -g RGB_SAMURAI_RED   "232;36;36";   set -g COM_SAMURAI_RED   "232,36,36"
set -g RONIN_YELLOW  "#FF9E3B"; set -g RGB_RONIN_YELLOW  "255;158;59";  set -g COM_RONIN_YELLOW  "255,158,59"
set -g WAVE_AQUA1    "#6A9589"; set -g RGB_WAVE_AQUA1    "106;149;137"; set -g COM_WAVE_AQUA1    "106,149,137"
set -g DRAGON_BLUE   "#658594"; set -g RGB_DRAGON_BLUE   "101;133;148"; set -g COM_DRAGON_BLUE   "101,133,148"


# ─── FISH THEME ──────────────────────────────────────────────────────────────── {{{
# fish_config theme choose kanagawa-wave
# Kanagawa Fish shell theme
# inlined
# A template was taken and modified from Tokyonight:
# https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_night.fish
set -l foreground DCD7BA normal
set -l selection 2D4F67 brcyan
set -l comment 727169 brblack
set -l red C34043 red
set -l orange FF9E64 brred
set -l yellow C0A36E yellow
set -l green 76946A green
set -l purple 957FB8 magenta
set -l cyan 7AA89F cyan
set -l pink D27E99 brmagenta

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

# (install via https://github.com/nicowillis/kanagawa-fish or similar)
# }}}

# ─── JQ COLORS ───────────────────────────────────────────────────────────────── {{{
#                 |       null        |      false       |       true       |     numbers      |     strings      |     arrays       |     objects      |       keys       |
#                 | bold Oni Violet   | Surimi Orange    | Surimi Orange    | Carp Yellow      | Spring Green     | Sumi Ink6        | Sumi Ink6        | bold Crystal Blue|
#                 | @constant.builtin | @boolean         | @boolean         | @number          | @string          | @punctuation     | @punctuation     | @property        |
set -gx JQ_COLORS "1;38;2;149;127;184:0;38;2;255;160;102:0;38;2;255;160;102:0;38;2;230;195;132:0;38;2;152;187;108:0;38;2;84;84;109:0;38;2;84;84;109:1;38;2;126;156;216"
# }}}

# ─── RIPGREP ─────────────────────────────────────────────────────────────────── {{{
function rg
    command rg \
        --heading \
        --line-number \
        --smart-case \
        --sort-files \
        --colors="path:fg:$COM_CRYSTAL_BLUE" \
        --colors="path:style:bold" \
        --colors="line:fg:$COM_SUMI_INK6" \
        --colors="column:fg:$COM_FUJI_GRAY" \
        --colors="match:fg:$COM_WAVE_RED" \
        --colors="match:style:bold" \
        --colors="match:bg:$COM_WAVE_BLUE1" \
        --colors="highlight:bg:$COM_SUMI_INK4" \
        $argv
end
# }}}

# ─── BAT ─────────────────────────────────────────────────────────────────────── {{{
set -gx BAT_THEME "kanagawa"
# bat cache --build if applying the first time
# Requires: https://github.com/rebelot/kanagawa.nvim (extras/kanagawa.tmTheme)
# or https://github.com/nicowillis/kanagawa-bat
# }}}

# ─── FZF ─────────────────────────────────────────────────────────────────────── {{{
set -gx FZF_DEFAULT_OPTS " \
    --color=bg+:$SUMI_INK4,bg:$SUMI_INK3,spinner:$SAKURA_PINK,hl:$WAVE_RED \
    --color=fg:$FUJI_WHITE,header:$WAVE_RED,info:$ONI_VIOLET,pointer:$SAKURA_PINK \
    --color=marker:$SAKURA_PINK,fg+:$FUJI_WHITE,prompt:$ONI_VIOLET,hl+:$WAVE_RED \
    --height=80% \
    --layout=reverse \
    --border \
    --margin=1 \
    --padding=1 \
    --preview 'bat --color=always --style=numbers --line-range :500 {}'"
# }}}

# ─── TIDE ────────────────────────────────────────────────────────────────────── {{{
# ── Prompt frame & structure ──────────────────────────────────────────────────
set -U tide_left_prompt_frame_color             54546D   # Sumi Ink6
set -U tide_right_prompt_frame_color            54546D   # Sumi Ink6
set -U tide_prompt_color_frame_and_connection   54546D
set -U tide_prompt_color_separator_same_color   363646  # Sumi Ink5

# ── OS ────────────────────────────────────────────────────────────────────────
set -U tide_os_bg_color                         7E9CD8   # Crystal Blue
set -U tide_os_color                            1F1F28   # Sumi Ink3 (base)
set -U tide_os_icon_bg_color                    9CABCA   # Spring Violet

# ── PWD ───────────────────────────────────────────────────────────────────────
set -U tide_pwd_bg_color                        7E9CD8   # Crystal Blue
set -U tide_pwd_color_anchors                   1F1F28   # Sumi Ink3
set -U tide_pwd_color_dirs                      1F1F28   # Sumi Ink3
set -U tide_pwd_color_truncated_dirs            2A2A37   # Sumi Ink4 (dimmed)

# ── Git ───────────────────────────────────────────────────────────────────────
set -U tide_git_bg_color                        98BB6C   # Spring Green  (clean)
set -U tide_git_bg_color_unstable               C0A36E   # Boat Yellow   (dirty)
set -U tide_git_bg_color_urgent                 E46876   # Wave Red      (urgent)
set -U tide_git_color_branch                    1F1F28   # Sumi Ink3
set -U tide_git_color_dirty                     1F1F28   # Sumi Ink3
set -U tide_git_color_staged                    1F1F28   # Sumi Ink3
set -U tide_git_color_untracked                 1F1F28   # Sumi Ink3
set -U tide_git_color_conflicted                1F1F28   # Sumi Ink3
set -U tide_git_color_operation                 1F1F28   # Sumi Ink3
set -U tide_git_color_stash                     1F1F28   # Sumi Ink3
set -U tide_git_color_upstream                  1F1F28   # Sumi Ink3

# ── Character (prompt symbol) ─────────────────────────────────────────────────
set -U tide_character_color                     98BB6C   # Spring Green  (success)
set -U tide_character_color_failure             E46876   # Wave Red      (failure)

# ── Status ────────────────────────────────────────────────────────────────────
set -U tide_status_bg_color                     98BB6C   # Spring Green
set -U tide_status_bg_color_failure             E46876   # Wave Red
set -U tide_status_color                        1F1F28   # Sumi Ink3
set -U tide_status_color_failure                1F1F28   # Sumi Ink3

# ── Command duration ──────────────────────────────────────────────────────────
set -U tide_cmd_duration_bg_color               C0A36E   # Boat Yellow
set -U tide_cmd_duration_color                  1F1F28   # Sumi Ink3

# ── Context (user@host) ───────────────────────────────────────────────────────
set -U tide_context_bg_color                    2A2A37   # Sumi Ink4
set -U tide_context_color_default               DCD7BA   # Fuji White
set -U tide_context_color_root                  E46876   # Wave Red      (root = danger)
set -U tide_context_color_ssh                   7FB4CA   # Spring Blue

# ── Jobs ──────────────────────────────────────────────────────────────────────
set -U tide_jobs_bg_color                       2A2A37   # Sumi Ink4
set -U tide_jobs_color                          C0A36E   # Boat Yellow

# ── Python ────────────────────────────────────────────────────────────────────
set -U tide_python_bg_color                     2A2A37   # Sumi Ink4
set -U tide_python_color                        7E9CD8   # Crystal Blue

# ── Node ──────────────────────────────────────────────────────────────────────
set -U tide_node_bg_color                       98BB6C   # Spring Green
set -U tide_node_color                          1F1F28   # Sumi Ink3

# ── Bun ───────────────────────────────────────────────────────────────────────
set -U tide_bun_bg_color                        2A2A37   # Sumi Ink4
set -U tide_bun_color                           DCD7BA   # Fuji White

# ── Go ────────────────────────────────────────────────────────────────────────
set -U tide_go_bg_color                         7FB4CA   # Spring Blue
set -U tide_go_color                            1F1F28   # Sumi Ink3

# ── Rust ──────────────────────────────────────────────────────────────────────
set -U tide_rustc_bg_color                      FFA066   # Surimi Orange
set -U tide_rustc_color                         1F1F28   # Sumi Ink3

# ── Ruby ──────────────────────────────────────────────────────────────────────
set -U tide_ruby_bg_color                       E46876   # Wave Red
set -U tide_ruby_color                          1F1F28   # Sumi Ink3

# ── PHP ───────────────────────────────────────────────────────────────────────
set -U tide_php_bg_color                        957FB8   # Oni Violet
set -U tide_php_color                           1F1F28   # Sumi Ink3

# ── Elixir ────────────────────────────────────────────────────────────────────
set -U tide_elixir_bg_color                     957FB8   # Oni Violet
set -U tide_elixir_color                        1F1F28   # Sumi Ink3

# ── Java ──────────────────────────────────────────────────────────────────────
set -U tide_java_bg_color                       FFA066   # Surimi Orange
set -U tide_java_color                          1F1F28   # Sumi Ink3

# ── Zig ───────────────────────────────────────────────────────────────────────
set -U tide_zig_bg_color                        E6C384   # Carp Yellow
set -U tide_zig_color                           1F1F28   # Sumi Ink3

# ── Kubectl ───────────────────────────────────────────────────────────────────
set -U tide_kubectl_bg_color                    7AA89F   # Wave Aqua
set -U tide_kubectl_color                       1F1F28   # Sumi Ink3

# ── Docker ────────────────────────────────────────────────────────────────────
set -U tide_docker_bg_color                     7E9CD8   # Crystal Blue
set -U tide_docker_color                        1F1F28   # Sumi Ink3

# ── gcloud ────────────────────────────────────────────────────────────────────
set -U tide_gcloud_bg_color                     7FB4CA   # Spring Blue
set -U tide_gcloud_color                        1F1F28   # Sumi Ink3

# ── AWS ───────────────────────────────────────────────────────────────────────
set -U tide_aws_bg_color                        FFA066   # Surimi Orange
set -U tide_aws_color                           1F1F28   # Sumi Ink3

# ── Terraform ─────────────────────────────────────────────────────────────────
set -U tide_terraform_bg_color                  957FB8   # Oni Violet
set -U tide_terraform_color                     1F1F28   # Sumi Ink3

# ── Pulumi ────────────────────────────────────────────────────────────────────
set -U tide_pulumi_bg_color                     C0A36E   # Boat Yellow
set -U tide_pulumi_color                        1F1F28   # Sumi Ink3

# ── Nix shell ─────────────────────────────────────────────────────────────────
set -U tide_nix_shell_bg_color                  7FB4CA   # Spring Blue
set -U tide_nix_shell_color                     1F1F28   # Sumi Ink3

# ── Direnv ────────────────────────────────────────────────────────────────────
set -U tide_direnv_bg_color                     C0A36E   # Boat Yellow
set -U tide_direnv_bg_color_denied              E46876   # Wave Red
set -U tide_direnv_color                        1F1F28   # Sumi Ink3
set -U tide_direnv_color_denied                 1F1F28   # Sumi Ink3

# ── Distrobox ─────────────────────────────────────────────────────────────────
set -U tide_distrobox_bg_color                  D27E99   # Sakura Pink
set -U tide_distrobox_color                     1F1F28   # Sumi Ink3

# ── Toolbox ───────────────────────────────────────────────────────────────────
set -U tide_toolbox_bg_color                    957FB8   # Oni Violet
set -U tide_toolbox_color                       1F1F28   # Sumi Ink3

# ── Vi mode ───────────────────────────────────────────────────────────────────
set -U tide_vi_mode_bg_color_default            54546D   # Sumi Ink6   (normal)
set -U tide_vi_mode_color_default               DCD7BA   # Fuji White
set -U tide_vi_mode_bg_color_insert             98BB6C   # Spring Green (insert)
set -U tide_vi_mode_color_insert                1F1F28   # Sumi Ink3
set -U tide_vi_mode_bg_color_replace            FFA066   # Surimi Orange (replace)
set -U tide_vi_mode_color_replace               1F1F28   # Sumi Ink3
set -U tide_vi_mode_bg_color_visual             957FB8   # Oni Violet  (visual)
set -U tide_vi_mode_color_visual                1F1F28   # Sumi Ink3

# ── Time ──────────────────────────────────────────────────────────────────────
set -U tide_time_bg_color                       363646   # Sumi Ink5
set -U tide_time_color                          DCD7BA   # Fuji White

# ── Shlvl ─────────────────────────────────────────────────────────────────────
set -U tide_shlvl_bg_color                      D27E99   # Sakura Pink
set -U tide_shlvl_color                         1F1F28   # Sumi Ink3

# ── Private mode ──────────────────────────────────────────────────────────────
set -U tide_private_mode_bg_color               54546D   # Sumi Ink6
set -U tide_private_mode_color                  DCD7BA   # Fuji White

# ── Crystal ───────────────────────────────────────────────────────────────────
set -U tide_crystal_bg_color                    7AA89F   # Wave Aqua
set -U tide_crystal_color                       1F1F28   # Sumi Ink3

# }}}

# vim: set foldmethod=marker:
