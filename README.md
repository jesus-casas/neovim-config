# Neovim Config

Personal Neovim configuration with lazy.nvim, LSP, Telescope, and more.

**Leader key:** `<Space>`

---

## Keybindings

### Window navigation
| Key | Action |
|-----|--------|
| `Ctrl+h` | Move to left window |
| `Ctrl+j` | Move to bottom window |
| `Ctrl+k` | Move to top window |
| `Ctrl+l` | Move to right window |
| `Space w` | Cycle through windows |

### File tree (Nvim-tree)
| Key | Action |
|-----|--------|
| `Space e` | Toggle file tree |

### Telescope (fuzzy finder)
| Key | Action |
|-----|--------|
| `Space ff` | Find files |
| `Space fg` | Live grep |
| `Space fb` | Find buffers |
| `Space fh` | Find help tags |

*In Telescope prompt:* `Ctrl+j` / `Ctrl+k` — move selection up/down.

### LSP
| Key | Action |
|-----|--------|
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `Space rn` | Rename symbol |
| `Space ca` | Code action |
| `Space f` | Format code |

### Completion (insert mode)
| Key | Action |
|-----|--------|
| `Ctrl+Space` | Trigger completion |
| `Enter` | Confirm selection |
| `Ctrl+e` | Abort completion |
| `Ctrl+b` / `Ctrl+f` | Scroll docs up/down |

### Terminal (ToggleTerm)
| Key | Action |
|-----|--------|
| `Ctrl+\` | Toggle main terminal |
| `Space tt` | Toggle terminal |
| `Space t1` | Toggle terminal 1 |
| `Space t2` | Toggle terminal 2 |
| `Space t3` | Toggle terminal 3 |
| `Space tf` | Toggle floating terminal |
| `Space tv` | Toggle vertical terminal |

*In terminal:* `Esc` or `Ctrl+\` — exit terminal mode / close.

---

## Plugins

- **Theme:** tokyonight
- **File tree:** nvim-tree
- **Status line:** lualine
- **Fuzzy finder:** Telescope
- **Syntax:** nvim-treesitter
- **LSP:** nvim-lspconfig + Mason
- **Completion:** nvim-cmp + LuaSnip
- **Other:** autopairs, Comment.nvim, which-key, gitsigns, indent-blankline, toggleterm