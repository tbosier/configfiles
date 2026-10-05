return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({})
    -- Installs any missing parsers in the background; already-installed ones are skipped.
    treesitter.install({ "c", "cpp", "cuda", "lua", "markdown", "markdown_inline", "python", "rust", "toml" })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "cpp", "cuda", "lua", "markdown", "python", "rust", "toml" },
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "cpp", "cuda", "lua", "python", "rust" },
      callback = function(args)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
