-- Basics
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.g.mapleader = " "

-- Enable syntax highlighting (Treesitter will override this for supported filetypes)
vim.cmd("syntax on")

-- Window navigation keybindings (easier than Ctrl+w)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<leader>w", "<C-w>w", { desc = "Cycle through windows" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false, -- needs to load before nvim-tree
  },

  -- Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  },

  -- File Tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 32, side = "left" },
        renderer = {
          group_empty = true,
          indent_markers = { enable = true },
          highlight_git = true,
          icons = {
            show = {
              folder = true,
              folder_arrow = true,
              file = true,
              git = true,
            },
          },
        },
        git = { enable = true },
      })

      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
    end,
  },

  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          section_separators = "",
          component_separators = "",
        },
      })
    end,
  },

  -- Telescope (Fuzzy Finder)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })

      -- Keybindings
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    priority = 1000, -- Load early
    config = function()
      local configs = require("nvim-treesitter.config")
      configs.setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "javascript", "typescript", "tsx",
          "python", "bash", "json",
          "yaml", "markdown", "html",
          "css", "scss", "rust", "go",
          "java", "c", "cpp", "make",
          "dockerfile", "gitignore"
        },
        sync_install = false,
        auto_install = false, -- Disabled to prevent errors with problematic parsers
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        indent = { enable = true },
      })
      
    end,
  },

  -- Mason (LSP/DAP/Formatter installer)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      -- Setup common LSP servers using new vim.lsp.config() API (Nvim 0.11+)
      -- Migration from require('lspconfig') to vim.lsp.config()
      -- Format: vim.lsp.config(server_name, config_table)
      vim.lsp.config("lua_ls", {})
      vim.lsp.config("ts_ls", {}) -- Updated from tsserver
      vim.lsp.config("pyright", {})
      vim.lsp.config("bashls", {})

      -- Keybindings for LSP
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, { desc = "Format code" })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Auto-pairs (auto-close brackets, quotes, etc.)
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
      -- Integrate with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Comment (easy commenting)
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Which-key (show available keybindings)
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
    end,
  },

  -- Git signs (show git changes in gutter)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Indent blankline (show indentation guides) - v3 API
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
        },
      })
    end,
  },

  -- ToggleTerm (Integrated Terminal - like VS Code)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = "<C-\\>",
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })

      -- Keybindings for terminals
      local Terminal = require("toggleterm.terminal").Terminal
      
      -- ESC to exit terminal mode and return to normal mode
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
      
      -- Main terminal (toggle with <C-\>)
      vim.keymap.set("n", "<leader>tt", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
      vim.keymap.set("t", "<C-\\>", "<Cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
      
      -- Create numbered terminals (terminal 1, 2, 3, etc.)
      vim.keymap.set("n", "<leader>t1", function()
        Terminal:new({ id = 1, direction = "horizontal" }):toggle()
      end, { desc = "Toggle terminal 1" })
      
      vim.keymap.set("n", "<leader>t2", function()
        Terminal:new({ id = 2, direction = "horizontal" }):toggle()
      end, { desc = "Toggle terminal 2" })
      
      vim.keymap.set("n", "<leader>t3", function()
        Terminal:new({ id = 3, direction = "horizontal" }):toggle()
      end, { desc = "Toggle terminal 3" })
      
      -- Floating terminal
      vim.keymap.set("n", "<leader>tf", function()
        Terminal:new({ direction = "float" }):toggle()
      end, { desc = "Toggle floating terminal" })
      
      -- Vertical split terminal
      vim.keymap.set("n", "<leader>tv", function()
        Terminal:new({ direction = "vertical", size = 50 }):toggle()
      end, { desc = "Toggle vertical terminal" })
    end,
  },

})
