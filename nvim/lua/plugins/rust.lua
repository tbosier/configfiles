return {
  {
    -- Runs rust-analyzer for .rs files, plus run/test/debug, macro expansion,
    -- and readable compiler errors. Keymaps live in lsp-config.lua (LspAttach).
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false, -- it lazy-loads itself on Rust files
    init = function()
      -- Use rustup's rust-analyzer proxy, not mason's copy (mason puts its own
      -- bin dir first on PATH). The proxy picks the toolchain the way rustup
      -- does everywhere else: your default, or an override for the directory
      -- Neovim was started in. Start nvim from the project root to be sure.
      local logfile = vim.fn.stdpath("log") .. "/rust-analyzer.log"
      local cmd
      for _, path in ipairs({ "/usr/lib/rustup/bin/rust-analyzer", vim.fn.expand("~/.cargo/bin/rust-analyzer") }) do
        if vim.uv.fs_stat(path) then
          -- Keep the log flag rustaceanvim's default command would pass.
          cmd = { path, "--log-file", logfile }
          break
        end
      end

      vim.g.rustaceanvim = {
        server = {
          cmd = cmd, -- nil falls back to whatever is on PATH
          logfile = logfile, -- what :RustLsp logFile opens
          default_settings = {
            ["rust-analyzer"] = {
              -- Show clippy lints on save, not just compiler errors.
              check = { command = "clippy" },
            },
          },
        },
      }
    end,
  },
  {
    -- Cargo.toml helper: shows latest crate versions inline, completes
    -- crate names/versions/features, and offers "upgrade" code actions.
    "saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" }, -- existing manifests; not one you are creating
    opts = {
      lsp = { enabled = true, actions = true, completion = true, hover = true },
    },
  },
}
