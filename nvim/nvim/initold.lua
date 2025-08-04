-- Set leader key
vim.g.mapleader = " "

-- Basic Options
vim.o.number = true
vim.o.termguicolors = true
vim.o.completeopt = "menu,menuone,noselect"

vim.cmd([[
  augroup TexFiletype
    autocmd!
    autocmd BufRead,BufNewFile *.tex set filetype=tex
  augroup END
]])


-- Plugin Manager: lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- Initialize Plugins with lazy.nvim
require("lazy").setup({
  -- Colorscheme
  { "ellisonleao/gruvbox.nvim" },

  -- Icons
  { "kyazdani42/nvim-web-devicons" },

  -- File Explorer
  { "nvim-tree/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons" } },

  -- Status Line
  { "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "benfowler/telescope-luasnip.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("luasnip")
    end,
  },

  -- Git Integration
  { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } },

  -- Indentation Guides
  { "lukas-reineke/indent-blankline.nvim" },

  -- Buffer Management
  { "akinsho/bufferline.nvim", requires = { "kyazdani42/nvim-web-devicons" } },

  -- Transparent Background
  { "xiyaowong/transparent.nvim" },

  -- Dashboard
  { "glepnir/dashboard-nvim" },

  -- LSP Configurations
  { "neovim/nvim-lspconfig" }, -- Collection of configurations for built-in LSP client

  -- Completion framework
  { "hrsh7th/nvim-cmp" },

  -- Completion sources
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Snippet engine
  { "L3MON4D3/LuaSnip" },

  -- Optional: Predefined snippets
  { "rafamadriz/friendly-snippets" },

  -- Auto Pairs
  { "windwp/nvim-autopairs" },

  -- Smooth Scrolling
  { "karb94/neoscroll.nvim" },

  -- Terminal Toggle
  { "akinsho/toggleterm.nvim", tag = '*' },

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },

  -- VimTeX for LaTeX support
  {
    "lervag/vimtex",
    ft = "tex", -- Load only for LaTeX files
    config = function()
      -- Set the PDF viewer (change 'zathura' to your preferred viewer)
      vim.g.vimtex_view_method = 'zathura' -- Alternatively, use 'general' for Windows viewers

      -- Configure VimTeX to use latexmk with XeLaTeX
      vim.g.vimtex_compiler_method = 'latexmk'

      -- Configure latexmk options
      vim.g.vimtex_compiler_latexmk = {
        build_dir = '', -- Directory to store build files; empty string for same directory
        callback = 1, -- Enable VimTeX callbacks
        continuous = 1, -- Enable continuous compilation
        executable = "latexmk",
        options = {
          '-pdf',        -- Generate PDF
          '-xelatex',    -- Use XeLaTeX; replace with '-lualatex' for LuaLaTeX
          '-synctex=1',  -- Enable SyncTeX
          '-interaction=nonstopmode', -- Non-interactive mode
          '-file-line-error',          -- Error format
        },
      }

      -- Optional: Enable forward and inverse search with the viewer
      vim.g.vimtex_view_general_viewer = 'zathura' -- Replace with your viewer if different
      vim.g.vimtex_view_general_options = '-unique file:@pdf#src:@line@tex'

      -- Optional: Disable automatic opening of the PDF viewer
      vim.g.vimtex_view_automatic = 0
    end,
  },
})

-- Neovim plugins for c++ 
require('lspconfig').clangd.setup{}

require("ibl").setup()


-- Colorscheme setup
require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = false,
    comments = false,
    operators = false,
    folds = false,
  },
  contrast = "hard",
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd([[colorscheme gruvbox]])

-- Transparent background
require("transparent").setup({
  enable = true,
  extra_groups = {
    "TelescopeNormal",
    "TelescopeBorder",
    "TelescopePromptNormal",
    "TelescopePromptBorder",
    "FloatBorder",
    "NormalFloat",
  },
  exclude = {},
})
vim.cmd([[autocmd ColorScheme * hi Normal ctermbg=none guibg=none]])
vim.cmd([[autocmd ColorScheme * hi NormalNC ctermbg=none guibg=none]])

-- nvim-tree setup
require("nvim-tree").setup({
  auto_reload_on_write = true,
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  auto_close = false,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  view = {
    width = 30,
    side = "left",
    mappings = {
      custom_only = false,
      list = {},
    },
  },
})

-- Keymap to toggle nvim-tree
vim.api.nvim_set_keymap(
  "n",
  "<C-n>",
  ":NvimTreeToggle<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
	"n",
	"<leader>tb",
	":belowright split | terminal<CR>",
	{ noremap = true, silent = true }
)

-- Keymap to compile c++ code automatically
vim.api.nvim_set_keymap(
  "n",
  "<leader>r",
  ":w<CR>:!g++ -O3 -march=native -o %:r % && ./%:r<CR>",
  { noremap = true, silent = true }
)


-- lualine setup
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "gruvbox",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})

-- Telescope setup
local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = " ",
    path_display = { "truncate" },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers
  },
  extensions = {
    luasnip = {
      -- Your extension configuration if any
    },
    -- Add other extensions here
  },
})

-- Load LuaSnip extension for Telescope
require("telescope").load_extension("luasnip")

-- Key mappings for Telescope
vim.api.nvim_set_keymap(
  "n",
  "<leader>ff",
  ":Telescope find_files<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fg",
  ":Telescope live_grep<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fb",
  ":Telescope buffers<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fh",
  ":Telescope help_tags<CR>",
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap("n", "<F5>", ":w<CR>:!python %<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-F5>", ":w<CR>:!clear; python %<CR>", { noremap = true, silent = true })


-- gitsigns setup
require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "契" },
    topdelete = { text = "契" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    interval = 1000,
    follow_files = true,
  },
  attach_to_untracked = true,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 1000,
    ignore_whitespace = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil,
  max_file_length = 40000,
})

-- indent-blankline setup
require("indent_blankline").setup({
  show_current_context = true,
  show_current_context_start = true,
  char = "┊",
  filetype_exclude = { "help", "packer", "dashboard", "NvimTree" },
  buftype_exclude = { "terminal", "nofile" },
  context_patterns = {
    "class",
    "function",
    "method",
    "^if",
    "^while",
    "^for",
    "block",
    "list_literal",
    "selector",
  },
})

-- bufferline setup
require("bufferline").setup({
  options = {
    numbers = "ordinal",
    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = '▎',
      style = 'icon',
    },
    buffer_close_icon = "",
    modified_icon = "●",
    close_icon = "",
    left_trunc_marker = "",
    right_trunc_marker = "",
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = ""
      for e, n in pairs(diagnostics_dict) do
        s = s .. e .. ":" .. n .. " "
      end
      return s
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true
      }
    },
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = false,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "slant",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
  },
})

-- Key mappings for bufferline
vim.api.nvim_set_keymap(
  "n",
  "<S-l>",
  ":BufferLineCycleNext<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<S-h>",
  ":BufferLineCyclePrev<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>bc",
  ":Bdelete!<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>bl",
  ":BufferLineMoveNext<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>bh",
  ":BufferLineMovePrev<CR>",
  { noremap = true, silent = true }
)

-- Dashboard setup
require('dashboard').setup({
  theme = 'hyper',
  config = {
    header = {
      " █████╗ ██████╗  ██████╗ ██╗   ██╗██╗███╗   ██╗ ██████╗ ",
      "██╔══██╗██╔══██╗██╔═══██╗██║   ██║██║████╗  ██║██╔════╝ ",
      "███████║██████╔╝██║   ██║██║   ██║██║██╔██╗ ██║██║  ███╗",
      "██╔══██║██╔══██╗██║   ██║██║   ██║██║██║╚██╗██║██║   ██║",
      "██║  ██║██║  ██║╚██████╔╝╚██████╔╝██║██║ ╚████║╚██████╔╝",
      "╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ ",
    },
    center = {
      {
        icon = "  ",
        desc = "Find File",
        key = "f",
        keymap = "SPC f f",
        action = "Telescope find_files",
      },
      {
        icon = "  ",
        desc = "Find Text",
        key = "g",
        keymap = "SPC f g",
        action = "Telescope live_grep",
      },
      {
        icon = "  ",
        desc = "File Explorer",
        key = "e",
        keymap = "SPC e",
        action = ":NvimTreeToggle<CR>",
      },
      {
        icon = "  ",
        desc = "Find Word",
        key = "w",
        keymap = "SPC f w",
        action = "Telescope grep_string",
      },
      {
        icon = "  ",
        desc = "Recently Used Files",
        key = "r",
        keymap = "SPC f h",
        action = "Telescope oldfiles",
      },
      {
        icon = "  ",
        desc = "Jump to File",
        key = "j",
        keymap = "SPC f j",
        action = "Telescope file_browser",
      },
      {
        icon = "  ",
        desc = "Open Project",
        key = "p",
        keymap = "SPC p p",
        action = "Telescope projects",
      },
      {
        icon = "  ",
        desc = "Config",
        key = "c",
        keymap = "SPC c e",
        action = ":e ~/.config/nvim/init.lua<CR>",
      },
    },
    footer = {
      "Happy Coding!",
    },
  },
})

-- Keymap to open dashboard
vim.api.nvim_set_keymap(
  "n",
  "<leader>;",
  ":Dashboard<CR>",
  { noremap = true, silent = true }
)

-- LuaSnip configuration
local luasnip = require("luasnip")

-- Load VSCode-style snippets (including friendly-snippets)
require("luasnip.loaders.from_vscode").lazy_load()

-- Load Lua-based snippets
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/" })
require("luasnip.loaders.from_snipmate").lazy_load({
  paths = { "~/.config/nvim/snippets" }
})
-- LuaSnip setup
luasnip.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
})

-- nvim-cmp setup
local cmp = require("cmp")

-- Helper function to check if there's a word before the cursor
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end
  local current_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return current_line:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    -- Confirm selection with Enter
    ['<CR>'] = cmp.mapping.confirm({ select = true }),

    -- Navigate through completion items
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

    -- Scroll documentation
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    -- Trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate snippet placeholders
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, vim_item)
      -- Define icons for different kinds
      local kind_icons = {
        Text = "",
        Method = "m",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }

      vim_item.kind = string.format("%s", kind_icons[vim_item.kind] or vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]

      return vim_item
    end,
  },
  window = {
    documentation = cmp.config.window.bordered(),
    completion = cmp.config.window.bordered(),
  },
})

-- Auto Pairs setup
require("nvim-autopairs").setup({
  check_ts = true,
})

-- Integrate cmp with autopairs
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- neoscroll setup
require("neoscroll").setup({
  mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
              '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
  hide_cursor = true,
  stop_eof = true,
  use_local_scrolloff = false,
  respect_scrolloff = false,
  cursor_scrolls_alone = true,
  easing_function = "quadratic",
  pre_hook = nil,
  post_hook = nil,
})

-- toggleterm setup
require("toggleterm").setup{
  size = 20,
  open_mapping = [[<C-t>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = '1',
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'float',
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = 'curved',
    winblend = 0,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
}

-- Key mapping to toggle terminal
vim.api.nvim_set_keymap(
  "n",
  "<leader>t",
  ":ToggleTerm<CR>",
  { noremap = true, silent = true }
)

-- Treesitter setup
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "latex", "vim", "python", "javascript", "bash" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
    },
  },
})
