return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      automatic_enable = false,
      -- rust-analyzer is deliberately NOT installed through mason. rustaceanvim
      -- (plugins/rust.lua) uses the rustup one, which tracks your installed
      -- toolchain. Mason's copy updates on its own schedule and can drift
      -- from the compiler, which breaks things like proc macros.
      ensure_installed = { "lua_ls", "pylsp", "clangd" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Tell every server that nvim-cmp can handle snippets and rich completion.
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then
        vim.lsp.config("*", { capabilities = cmp_lsp.default_capabilities() })
      end

      -- Rust is NOT enabled here: rustaceanvim runs rust-analyzer itself, and
      -- two rust-analyzer clients on one buffer fight each other.
      vim.lsp.enable({ "lua_ls", "pylsp" })

      -- Neovim 0.11+ hides inline error text by default. Bring it back.
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, source = "if_many" },
        float = { border = "rounded", source = true },
        underline = true,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspKeys", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>cf", function() vim.lsp.buf.format({ bufnr = buf }) end, "Format file")
          map("n", "<leader>cd", vim.diagnostic.open_float, "Show this line's problems")

          -- Inlay hints: the greyed-out types Rust infers for you. On by default.
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
            map("n", "<leader>ih", function()
              local on = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
              vim.lsp.inlay_hint.enable(not on, { bufnr = buf })
            end, "Toggle inlay hints")
          end

          if client and client.name == "rust-analyzer" then
            -- Rust gets richer versions from rustaceanvim.
            map("n", "K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover (with actions)")
            map({ "n", "v" }, "<leader>ca", function() vim.cmd.RustLsp("codeAction") end, "Code action")
            map("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Run (pick target)")
            map("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end, "Run tests (pick)")
            map("n", "<leader>rl", function() vim.cmd.RustLsp({ "testables", bang = true }) end, "Re-run last test")
            map("n", "<leader>re", function() vim.cmd.RustLsp("explainError") end, "Explain next error")
            map("n", "<leader>rd", function() vim.cmd.RustLsp("renderDiagnostic") end, "Full compiler message")
            map("n", "<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, "Expand macro")
            map("n", "<leader>rc", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
            map("n", "<leader>rp", function() vim.cmd.RustLsp("parentModule") end, "Parent module")
            map("n", "<leader>ro", function() vim.cmd.RustLsp("openDocs") end, "Open docs for symbol")

            -- rustfmt on save, the same thing `cargo fmt` does.
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("RustFormat" .. buf, { clear = true }),
              buffer = buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = buf, timeout_ms = 2000 })
              end,
            })
          else
            map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          end
        end,
      })
    end,
  },
}
