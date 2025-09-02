# LazyVim Cheatsheet

## Navigation / Movement

| Shortcut   | Aktion                           |     | Shortcut  | Aktion                |
| ---------- | -------------------------------- | --- | --------- | --------------------- |
| `<C-f>`    | Forward (Page down)              |     | `<C-b>`   | Backward (Page up)    |
| `<C-d>`    | Move down (Half a page)          |     | `<C-u>`   | Move up (Half a page) |
| zb/zt      | Place current line at bottom/top |     | zz        | Center current line   |
| `<C-o>`    | Jump back                        |     | `<C-i>`   | Jump forward          |
| `gg`       | Go to first line                 |     | `Shift-G` | Go to last line       |
| `:10,10gg` | Jump to line#10                  |     | `10j`     | Jump down 10 lines    |
| `10k`      | Jump up 10 lines                 |     | `J`       | Join lines            |

---

## UI Toggles / Buffers

| Shortcut     | Aktion                    |     | Shortcut       | Aktion               |
| ------------ | ------------------------- | --- | -------------- | -------------------- |
| `<leader>uC` | Colorscheme with preview  |     | `<leader>fb`   | List open buffers    |
| `<leader>uD` | Enable code block dimming |     | `<Shift>l/h`   | Next/Prev buffer     |
| `<leader>ul` | Toggle line number        |     | `]b / [b`      | Next/Prev buffer     |
| `<leader>uL` | Toggle relative number    |     | `<leader>bd`   | Close current buffer |
| `<leader>uw` | Toggle word wrap          |     | `<C-w>v`       | Split vertical       |
| `<C-/>`      | Toggle Terminal window    |     | `<C-w>s`       | Split horizontal     |
| `:Neotree`   | Neotree file explorer     |     | `<C-w>h/j/k/l` | Navigate splits      |

---

## Visual / Text Objects

| Shortcut | Aktion                    |     | Shortcut | Aktion                  |
| -------- | ------------------------- | --- | -------- | ----------------------- |
| `viw`    | Select inner word         |     | `vi"`    | Select inner quotes     |
| `vi{`    | Select inner curly braces |     | `vip`    | Select inner paragraph  |
| `va[`    | Select around `[]` braces |     | `dap`    | Delete around paragraph |

---

## Folding / Marks

| Shortcut  | Aktion                        |     | Shortcut        | Aktion                    |
| --------- | ----------------------------- | --- | --------------- | ------------------------- |
| `zR / zi` | Open all folds                |     | `<leader>sm`    | View all marks            |
| `zM`      | Close all folds               |     | `m[a-z]`        | Set local mark            |
| `za`      | Toggle fold                   |     | `'[a-z]`        | Jump to mark              |
| `zA`      | Toggle all folds under cursor |     | `' '`           | Jump to last position     |
| `zc`      | Close fold                    |     | `'[a-z]'`       | Jump to exact position    |
| `zo`      | Open fold                     |     | `:delmarks a-z` | Delete lowercase marks    |
| `zO`      | Open all folds under cursor   |     | `:delmarks ax`  | Delete marks a & x        |
|           |                               |     | `:delmarks!`    | Delete all except A-Z,0-9 |

---

## LSP / Diagnostics

| Shortcut     | Aktion                    |     | Shortcut     | Aktion                |
| ------------ | ------------------------- | --- | ------------ | --------------------- |
| `:LspInfo`   | Show attached LSP info    |     | `]d`         | Next diagnostic       |
| `<leader>cs` | Document symbols          |     | `[d`         | Prev diagnostic       |
| `gr`         | Find all references       |     | `<leader>sd` | Document diagnostics  |
| `gd`         | Go to definition          |     | `<leader>sD` | Workspace diagnostics |
| `gD`         | Go to declaration         |     |              |                       |
| `gy`         | Go to Type definition     |     |              |                       |
| `K`          | Show docstring/type hints |     |              |                       |
| `[[ / ]]`    | Prev / Next reference     |     |              |                       |

---

## Refactoring / Code Actions

| Shortcut     | Aktion         |     | Shortcut     | Aktion      |
| ------------ | -------------- | --- | ------------ | ----------- |
| `<leader>cr` | Rename symbols |     | `<leader>cf` | Format code |
| `<leader>ca` | Code actions   |     |              |             |

---

## Indentation / Search & Symbols

| Shortcut | Aktion                      |     | Shortcut     | Aktion                   |
| -------- | --------------------------- | --- | ------------ | ------------------------ |
| `>`      | Indent right                |     | `<leader>sr` | Search and Replace       |
| `<`      | Indent left                 |     | `<leader>fc` | Find Config files        |
| `=`      | Auto-indent as per language |     | `<leader>ff` | Find files (Root dir)    |
| `=ip`    | Indent current paragraph    |     | `<leader>/`  | Grep (Root dir)          |
| `gg=G`   | Auto-indent entire file     |     | `<leader>sG` | Grep (CWD)               |
|          |                             |     | `<leader>ss` | Symbol search            |
|          |                             |     | `<leader>sc` | Command history          |
|          |                             |     | `<leader>sw` | Search word under cursor |
|          |                             |     | `<leader>sk` | Search all keymaps       |
|          |                             |     | `<leader>st` | Search TODO/Warning      |

---

## Git / Git Extras

| Shortcut     | Aktion                 |     | Shortcut     | Aktion                |
| ------------ | ---------------------- | --- | ------------ | --------------------- |
| `<leader>gc` | Commit log texts       |     | `<leader>gs` | Status (file search)  |
| `<leader>ge` | Git explorer (Neotree) |     | `<leader>gf` | Current file history  |
| `<leader>gg` | Open LazyGit window    |     | `<C-r>`      | Switch to recent repo |
| `<C-b>`      | Filter files by status |     | `p`          | Git pull              |
| `P`          | Git push               |     | `<space>`    | Stage                 |
| `a`          | Stage all              |     | `c`          | Commit                |
| `s`          | Stash                  |     | `z`          | Undo                  |
| `<C-z>`      | Redo                   |     | `i`          | Add to .gitignore     |
| `q`          | Quit                   |     |              |                       |
