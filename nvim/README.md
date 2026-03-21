# Neovim Learning Journal & Reference

**What this file is:** Two things at once.

1. A record of what we've covered, written from Claude's perspective as your
   teacher — so you can re-read it when work takes over for a week and you
   come back wondering "wait, how did that work again?"

2. A handoff document — if you start a new Claude session, upload this file
   along with your config files and the new session can immediately understand
   where you are, what the teaching philosophy has been, and what to do next.

Keep this file in your config repo. Update it (or ask Claude to update it)
as you make progress.

---

## Session Log

A running record of what got done and when, so future sessions can see
progress at a glance.

**Session — March 2026**
- Built `zls` from source (`0.16.0-dev.280+3ec65a81`) and installed to `/opt/sbin/`
- Wrote `ftplugin/zig.lua` independently — tree-sitter, indent, LSP, buffer-local
  keymaps, format on save. Got it mostly right without the journal, just needed
  the reminder on the LSP block.
- Verified tree-sitter working with `:InspectTree` — remembered this unprompted.
- `mini.completion` working with `zls` out of the box.
- Understood `root_dir` / `vim.fs.root()` — the upward-walking marker search,
  and why it's also the LSP deduplication key.
- Understood why LSP keymaps belong in `ftplugin` with `{ buffer = 0 }` and not
  in a global keymaps file — "the config becomes true, not just functional."
- Started understanding `require()` / `return` — the module mechanic underlying
  both the bootstrap function and lazy.nvim's "return a table" pattern.
- Learned that `require()` caches — file runs once, same value returned every
  subsequent call. Needs full restart (or `package.loaded` clear) to reload.
- Context: was mid-session learning Zig in a separate Claude session. Came here
  on a dinner break specifically to get LSP working before returning to Zig.
  Journal worked exactly as intended — reoriented from zero in one sitting.

---

## How This Started

You came to me having done AI-assisted Neovim configuration before. You had a
full setup — colorschemes, LSPs, plugins, keymaps, the works. A lot of it was
"working." The problem: you had absolutely no idea how or why any of it worked.
It was a black box you'd been handed.

So you threw it away. That was exactly the right call.

You came back with a specific request: *teach me Neovim the right way. No plugin
managers. I want to understand what's actually happening.* You'd also heard that
Neovim 0.12 (which you're running as a nightly) has a native package manager
built in, and you wanted to understand that rather than layer something on top of it.

That's where we started.

---

## The Teaching Philosophy

The core principle we've been working from: **Neovim provides all the building
blocks through its Lua API. Plugins are mostly just someone else's arrangement
of those same building blocks.** Once you can see the blocks, the plugins stop
being magic and start being optional.

The scratch buffer was the first real demonstration of this. You mentioned
missing the scratch buffer from `snacks.nvim` — a plugin you'd used before but
didn't understand. We built one from scratch in about 15 lines:

```lua
local buf = vim.api.nvim_create_buf(false, true)   -- create a buffer
vim.api.nvim_open_win(buf, true, { ... })           -- open it in a float
vim.bo[buf].buftype = ""
vim.api.nvim_buf_set_name(buf, scratch_file)        -- back it with a real file
```

That's it. That's what `snacks.nvim` is doing internally — calling the same
API functions, just with more configuration options and polish around it. The
moment you saw that, something clicked: *all of that is just Lua calling
Neovim's API.* Every plugin you thought you needed is doing the same thing.

**On structure:** We deliberately did not start with a clean hierarchical
config. The instruction was: *put everything in `init.lua` first. Get it
working. Understand what each line does. Worry about organisation later.*
This was intentional — learning to split things into files before you
understand what the files contain just creates confusion without comprehension.
The current mess in `init.lua` is a normal and expected stage of learning.
It means you're building understanding, not copying someone else's structure.

---

## What You're Running

- **Neovim:** nightly, `0.16.0-dev.2960+ce1f7136a`, at `/opt/sbin/nvim`
- **Zig compiler:** `0.16.0-dev.2960+ce1f7136a` at `/opt/sbin/zig`
  (tracking master for the new IO system — release is close)
- **ripgrep:** installed, used by `mini.pick` for file/text search
- **efm-langserver:** installed, wraps `shellcheck` for shell file linting
- **zls:** built and installed, `0.16.0-dev.280+3ec65a81`, at `/opt/sbin/zls`

---

## Current Config — What Exists and Why

### File tree

```
~/.config/nvim/
├── init.lua                    ← everything lives here for now, intentionally
├── lua/
│   └── plugins.lua             ← the plugin list (just a Lua table)
├── floating_terminal.lua       ← needs to move into lua/ (see known issues)
├── ftplugin/
│   ├── sh.lua                  ← shell files: tree-sitter + efm-langserver LSP
│   ├── soql.lua                ← Salesforce SOQL: tree-sitter
│   └── yaml.lua                ← YAML: tree-sitter
└── ftdetect/
    ├── soql.lua                ← registers .soql extension as "soql" filetype
    └── yaml.lua                ← empty, Neovim already knows yaml
```

### `lua/plugins.lua`

A plain Lua table. Each entry has a `repo` (GitHub slug) and a `path` (where
it should live on disk). The bootstrap function in `init.lua` reads this table
and `git clone`s anything not already present. That's the whole plugin manager.

Two plugins:

- **`catppuccin/nvim`** — colorscheme, mocha flavour, transparent background
- **`echasnovski/mini.nvim`** — a collection of small independent modules

Mini modules in use: `statusline`, `icons`, `pick` (fuzzy finder), `extra`,
`notify`, `files` (file explorer), `completion` (autocomplete).

### `init.lua`

One big file, by design for now. In order:

1. **Leader key** — `vim.g.mapleader = " "` (Space). Must be set before any
   keymaps, otherwise they register with the wrong leader.

2. **Bootstrap** — loops over `plugins.lua`, `git clone --depth=1`s anything
   missing. First launch: clones everything. After that: does nothing.

3. **Catppuccin** — `require("catppuccin").setup({ flavour = "mocha", ... })`.
   The first example of passing a config table to a plugin. Just Lua.

4. **Mini modules** — each needs an explicit `.setup()` call. You only get
   what you ask for.

5. **Keymaps** — `vim.keymap.set(mode, keys, action, opts)`.

6. **Scratch buffer** — floating window backed by
   `~/.local/share/nvim/scratch.md`. Built from raw Neovim API to demonstrate
   that plugins aren't needed for this kind of thing.

   ⚠️ **Bug:** defined twice. Second definition silently overwrites the first,
   losing the toggle behaviour. First thing to fix.

7. **Editor options** — numbers, indentation, diagnostic display.

### `floating_terminal.lua`

Tracks a terminal buffer and window in module-level variables so the shell
session persists between open/close cycles. Uses a `TermClose` autocommand
to clean up state when the shell exits.

⚠️ **Structural issue:** Lives at the config root, can't be `require()`d from
there. Needs to move to `lua/`. `init.lua` also has a simpler competing
`float_term` inline. Two implementations of the same thing — needs a cleanup.

### `ftplugin/zig.lua` ✓

Tree-sitter, 4-space indent, `zls` LSP, buffer-local keymaps (`gd`, `gr`,
`K`, `<leader>rn`, `<leader>ca`), and format-on-save via `BufWritePre`.
This file is the worked example of everything the `ftplugin` concept is for.

```lua
vim.treesitter.language.register("bash", "sh")
vim.bo.syntax = "off"
vim.treesitter.start()
vim.lsp.start({ name = "efm", cmd = { "efm-langserver" }, ... })
```

Tree-sitter uses the `bash` grammar for `sh` files (same language, different
name). Old regex syntax is disabled. `efm-langserver` provides LSP diagnostics
by wrapping `shellcheck`.

### `ftplugin/soql.lua` and `ftplugin/yaml.lua`

Same tree-sitter pattern. No LSP yet on either.

### `ftdetect/soql.lua`

```lua
vim.filetype.add({ extension = { soql = "soql" } })
```

Without this, `.soql` files would have no filetype assigned and
`ftplugin/soql.lua` would never fire.

---

## Concepts Covered — Reference

This section is the "I forgot how this works" reference. Re-read this when
you come back after a gap.

---

### How Neovim loads your config

```
Neovim starts
  │
  ├── runs every file in ftdetect/
  │     → this is where custom filetypes get registered
  │
  ├── loads plugins from pack/*/start/
  │     → any directory here is a plugin, no registration needed
  │
  ├── runs init.lua
  │     → your main config: options, keymaps, colorscheme, etc.
  │
  └── you open a file
        → Neovim detects the filetype
        → runs ftplugin/<filetype>.lua for that buffer
```

`ftplugin` runs *per buffer*, not once at startup. Every time you open a
`.zig` file, `ftplugin/zig.lua` runs fresh. This is what makes per-filetype
config work without any extra machinery.

---

### The native package system

Place a directory at:
```
~/.local/share/nvim/site/pack/<namespace>/start/<plugin-name>/
```
Neovim loads it automatically on startup. That's the whole system.

- `<namespace>` can be anything — just for your own organisation
- `start/` means "load immediately" (vs `opt/` which means "load on demand")
- A plugin manager like `lazy.nvim` just automates populating this directory

`vim.fn.stdpath("data")` gives you `~/.local/share/nvim` in a
platform-correct way.

---

### Tree-sitter

A parsing system that understands actual code grammar, replacing Neovim's
old regex-based syntax highlighting. More accurate, enables structural
features (select a whole function, etc.).

**Basic usage in `ftplugin`:**
```lua
vim.bo.syntax = "off"       -- turn off the old regex system
vim.treesitter.start()      -- start tree-sitter for this buffer
```

**When the grammar name doesn't match the filetype name:**
```lua
-- The grammar is called "bash" but the filetype is "sh"
vim.treesitter.language.register("bash", "sh")
vim.bo.syntax = "off"
vim.treesitter.start()
```

You need a parser installed for each language. You've installed: `bash`,
`yaml`, `soql`, `zig`.

**Verifying tree-sitter is actually working:**

```
:InspectTree
```

Opens a split showing the parsed syntax tree for the current buffer. If you
see a real tree with named nodes (`function_definition`, `identifier`,
`string_literal` etc.), tree-sitter is working. If it's empty or errors,
either the parser isn't installed or `vim.treesitter.start()` didn't run.

This is your first debugging tool when filetype config isn't behaving. Open
a file, run `:InspectTree`, and you immediately know whether tree-sitter is
active or not. No guessing.

---

### LSP (Language Server Protocol)

A separate program that analyses your code and sends diagnostics,
completions, definitions, etc. to any editor that speaks the protocol.
Neovim has a built-in LSP client — no plugin needed.

**Starting an LSP in `ftplugin`:**
```lua
vim.lsp.start({
    name     = "zls",           -- any name, used for display and deduplication
    cmd      = { "zls" },       -- the command to start the server
    root_dir = vim.fs.root(0, { "build.zig", "build.zig.zon", ".git" }),
})
```

If a server with the same `name` and `root_dir` is already running, Neovim
reuses it — no duplicate servers.

---

#### Why `root_dir` exists — and what `vim.fs.root()` actually does

This is something almost no tutorial explains, and it matters.

When `zls` starts, it doesn't just look at the single file you have open.
It needs to understand your *project* — where's the `build.zig`? What are
all the source files? What packages are you importing? It needs a starting
point to answer those questions. `root_dir` is the answer to: **"where is
the top of this project?"**

```lua
root_dir = vim.fs.root(0, { "build.zig", "build.zig.zon", ".git" })
```

Breaking this down:

- `0` means "start from the directory of the current buffer"
- The table is a list of **marker files** to search for
- `vim.fs.root()` walks *upward* from your current file, directory by
  directory, until it finds a directory containing one of those markers

So if you open `/home/you/projects/myapp/src/main.zig`, it searches like this:

```
/home/you/projects/myapp/src/   ← build.zig here? No.
/home/you/projects/myapp/       ← build.zig here? YES. Stop.
```

And returns `/home/you/projects/myapp/` as the root. The markers are chosen
because `build.zig` at the top of a directory means "this is the root of a
Zig project." `.git` is the fallback for when there's no `build.zig` yet.

**Why this also prevents duplicate LSP servers:**

Neovim identifies a running LSP server by its `name` + `root_dir` together.
If you open `src/main.zig` and then `src/utils.zig` from the same project,
both resolve to the same `root_dir`. Neovim sees "zls is already running for
this root" and attaches the existing server to the new buffer instead of
spawning a second one. One `zls` per project, no matter how many files you
open. This is why `root_dir` matters — it's not just location metadata, it's
the key Neovim uses to decide whether to reuse or create.

---

#### Why LSP keymaps belong in `ftplugin`, not a global keymaps file

This is the other thing tutorials get wrong — or just never explain.

You might have seen configs (or written one yourself) that put `gd`, `K`,
`<leader>rn` etc. in a global `keymaps.lua`. It works. But it's
philosophically wrong in a way that only becomes obvious once you understand
what these keys actually *are*.

`gd` (go to definition) only makes sense when there's an LSP attached to the
current buffer. Put it in a global keymaps file and it exists in every buffer
— your YAML files, your shell scripts, your scratch buffer — whether an LSP
is there or not. At best it does nothing. At worst it does something
unexpected.

`{ buffer = 0 }` in `ftplugin/zig.lua` means `gd` only exists when you're
in a Zig file. That's the *correct* expression of what you actually want.

This is the deeper pattern you keep finding: the "right way" isn't just more
organised — it more accurately describes your actual intent. A global
keymaps file is a pile of things that happen to work. Buffer-local keymaps
in `ftplugin` is a description of what those keys *mean* and *when they
should exist*. The config becomes true, not just functional.

---

**Useful LSP commands (run in normal mode):**
```
:LspInfo       — show attached LSP servers for the current buffer
:LspStop       — stop the LSP for this buffer
:LspRestart    — restart it
```

**Common LSP keymaps (set with `{ buffer = 0 }` in ftplugin):**
```lua
vim.keymap.set("n", "gd",         vim.lsp.buf.definition,  { buffer = 0, desc = "Go to definition" })
vim.keymap.set("n", "gr",         vim.lsp.buf.references,  { buffer = 0, desc = "Find references" })
vim.keymap.set("n", "K",          vim.lsp.buf.hover,       { buffer = 0, desc = "Hover docs" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,      { buffer = 0, desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0, desc = "Code action" })
```

---

### Autocommands

Neovim's event system. "When X happens, run Y."

```lua
vim.api.nvim_create_autocmd("BufWritePre", {
    buffer   = 0,                    -- scope to current buffer only
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
    desc = "Format on save",
})
```

**Common events:**

| Event | When it fires |
|---|---|
| `BufWritePre` | Just before saving a file |
| `BufWritePost` | Just after saving a file |
| `TermClose` | When a terminal process exits |
| `FileType` | When a filetype is detected |
| `BufEnter` | When you enter a buffer |

**Always use `{ buffer = 0 }` inside `ftplugin` files** so the autocommand
only fires for that specific buffer, not every buffer of that type globally.
(This is a subtle but important distinction — without it, the autocommand
fires for every buffer Neovim ever opens of that filetype, even ones opened
later in the session.)

---

### How to add support for a new filetype

**Step 1: Do you need `ftdetect`?**

Check if Neovim already knows the filetype:
```
:set filetype?
```
If it returns `filetype=` (empty), you need `ftdetect`. Common languages
(Zig, Python, Lua, C, Rust, JS) are already known. Unusual extensions
(`.soql`, `.tf`, `.gleam`) are not.

**Step 2: Create `ftdetect/<name>.lua` if needed**

```lua
-- By file extension
vim.filetype.add({ extension = { soql = "soql" } })

-- By exact filename
vim.filetype.add({ filename = { ["Dockerfile"] = "dockerfile" } })

-- By pattern (Lua patterns, not regex)
vim.filetype.add({ pattern = { ["%.env%..+"] = "sh" } })
```

**Step 3: Create `ftplugin/<name>.lua`**

Template — use the parts relevant to your language:

```lua
-- ftplugin/yourlang.lua

-- tree-sitter
-- (only need register() if grammar name differs from filetype name)
vim.bo.syntax = "off"
vim.treesitter.start()

-- buffer-local options (vim.opt_local = this buffer only)
vim.opt_local.tabstop    = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab  = true
vim.opt_local.colorcolumn = "100"   -- visual ruler

-- LSP
vim.lsp.start({
    name     = "your-lsp-server",
    cmd      = { "your-lsp-binary" },
    root_dir = vim.fs.root(0, { "your-project-marker", ".git" }),
})

-- buffer-local keymaps (only active in this filetype's buffers)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0, desc = "Go to definition" })
vim.keymap.set("n", "K",  vim.lsp.buf.hover,      { buffer = 0, desc = "Hover docs" })

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    buffer   = 0,
    callback = function() vim.lsp.buf.format({ async = false }) end,
})
```

**Quick reference:**

| What | How |
|---|---|
| Tree-sitter highlighting | `vim.bo.syntax = "off"` + `vim.treesitter.start()` |
| Grammar name ≠ filetype | `vim.treesitter.language.register("grammar", "ft")` |
| Buffer-local option | `vim.opt_local.tabstop = 4` |
| Visual column ruler | `vim.opt_local.colorcolumn = "100"` |
| Start an LSP | `vim.lsp.start({ name, cmd, root_dir })` |
| Format on save | `BufWritePre` autocmd → `vim.lsp.buf.format()` |
| Buffer-local keymap | `vim.keymap.set(..., { buffer = 0 })` |
| Spell checking | `vim.opt_local.spell = true` |

---

### Lua — the bits you need for config work

```lua
-- Variables — always use local
local x = 42
local s = "hello"

-- String concatenation
local path = vim.fn.stdpath("data") .. "/site/pack"

-- Tables — Lua's only data structure, used for everything
local arr  = { "one", "two", "three" }          -- array-like
local map  = { name = "zls", cmd = "zls" }      -- key-value
local nest = { { repo = "a", path = "b" } }     -- tables inside tables

-- Iterating a table
for index, value in ipairs(arr) do   -- ipairs = ordered, for arrays
    print(index, value)
end

for key, value in pairs(map) do      -- pairs = unordered, for maps
    print(key, value)
end

-- Functions
local function greet(name)
    print("Hello, " .. name)
end
greet("world")

-- The vim global — Neovim's entire API lives here
vim.opt.number = true              -- set an option globally
vim.opt_local.tabstop = 4          -- set an option for this buffer
vim.bo.syntax = "off"              -- buffer option (raw access)
vim.g.mapleader = " "              -- global variable
vim.fn.stdpath("data")             -- call a Vim function
vim.api.nvim_create_buf(false, true)  -- call a low-level API function
vim.cmd.colorscheme("catppuccin")  -- run a Vim command

-- require() — loading modules
-- require("foo") loads lua/foo.lua and returns what that file returns
-- require("foo.bar") loads lua/foo/bar.lua
local catppuccin = require("catppuccin")
catppuccin.setup({ flavour = "mocha" })

-- More commonly written as one line:
require("catppuccin").setup({ flavour = "mocha" })
-- This is NOT magic. It's: load module → get table back → call .setup() on it.
-- The { flavour = "mocha" } is just a table passed as a function argument.
```

---

## Current Keymaps

`<leader>` = Space

| Mode | Key | Action |
|---|---|---|
| Normal | `<Space>e` | Open file explorer (MiniFiles) |
| Normal | `<Space>ff` | Find files |
| Normal | `<Space>fb` | Find open buffers |
| Normal | `<Space>fg` | Live grep (search file contents) |
| Normal | `<Space>fd` | Diagnostics picker |
| Normal | `<Space>t` | Toggle floating terminal |
| Normal | `<Space>S` | Toggle scratch buffer |
| Normal | `<Space>so` | Reload init.lua |
| Normal | `<Space>y` | Yank to system clipboard |
| Normal | `<Space>d` | Show diagnostic float |
| Insert | `jk` | Exit insert mode |
| Terminal | `<Space>t` | Close terminal |

---

## Known Issues

**1. Duplicate `scratch` function in `init.lua`**
Defined twice. Second definition silently overwrites the first, losing the
"close if already open" toggle behaviour. Find both, pick one, delete the
other and its duplicate `vim.keymap.set`.

**2. `floating_terminal.lua` is in the wrong place**
Lives at config root. Can't be `require()`d from there — Lua only searches
inside `lua/`. Also, `init.lua` has a simpler competing `float_term` inline.
Two implementations of the same feature. Needs consolidation.

---

## What To Do Next

### Right now — ready to do today

**Fix the scratch bug.**
Open `init.lua`, find the two `scratch` function definitions and the two
`<Space>S` keymaps. Pick the one with the "close if already open" logic
(the first one), delete the second function and its keymap.

---

### Soon — when init.lua starts feeling crowded

**Reorganize into `lua/`.**

`require("something")` loads `lua/something.lua`. `require("ui.something")`
loads `lua/ui/something.lua`. Neovim puts `~/.config/nvim/lua/` on Lua's
search path automatically.

The goal: an `init.lua` that's just a table of contents:

```lua
vim.g.mapleader = " "
require("bootstrap")
require("options")
require("keymaps")
require("ui.theme")
require("ui.statusline")
require("ui.scratch")
require("ui.terminal")   -- floating_terminal.lua moves here
```

Suggested split:
```
lua/
├── bootstrap.lua       ← the git clone loop
├── options.lua         ← all vim.opt.* settings
├── keymaps.lua         ← global keymaps
└── ui/
    ├── theme.lua       ← catppuccin setup
    ├── statusline.lua  ← mini.statusline + mini.icons
    ├── scratch.lua     ← scratch buffer
    └── terminal.lua    ← floating terminal
```

**Do this one section at a time.** Move one thing, reload with `<Space>so`,
confirm it still works. Then move the next. Not all at once.

---

### Later — deeper understanding

**Read a plugin's source.**
Go to `~/.local/share/nvim/site/pack/plugins/start/mini.nvim/lua/mini/`
and open `completion.lua`. Find `M.setup = function(config)`. That `config`
is the table you pass from your `init.lua`. A function parameter. Not magic.
This is the moment where plugins stop being black boxes.

**Understand `vim.opt` vs `vim.bo` vs `vim.o`.**
You've used all three but haven't mapped out the full difference. Worth a
dedicated session once the current work is done.

**The native package manager in 0.12.**
It's on your list and worth a full session. It builds directly on everything
you already know about how the `pack/` directory works.

**`vim.fs` and `vim.system`.**
Newer Neovim APIs (very relevant on your nightly build) for file operations
and running external commands cleanly from Lua.

---

## Note for Future Claude Sessions

The person you're working with deliberately threw away a working-but-opaque
Neovim config to learn from scratch. Keep these things in mind:

- **Explain why before how.** The mechanism matters more than the shortcut.
- **When they want a feature, build it from the API first**, then mention
  that a plugin exists for it. The scratch buffer moment was the model for
  this — show the building blocks, then reveal that the plugin is just
  a polished wrapper around the same blocks.
- **Don't push reorganisation** until they feel the pain of disorganisation
  themselves. `init.lua` is still manageable. Let them feel when it isn't.
- **They're a Zig person** tracking `0.16.0-dev` master for the new IO
  system. Zig's "understand your tools" philosophy maps directly onto the
  approach we're taking with Neovim. Use that connection.
- **They come back after gaps.** Work happens. The reference sections in
  this document exist specifically so they can re-orient without starting
  a whole new teaching session. Point them to the relevant section first.
- **The config files are the ground truth.** Always read them before
  suggesting changes — don't assume the current state matches past sessions.
