return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    -- Keymaps
    vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})
    vim.keymap.set("n", "<leader>1", "<C-w>h", { desc = "Focus NeoTree" })
    vim.keymap.set("n", "<leader>2", "<C-w>l", { desc = "Focus code window" })

    -- Neo-tree setup WITH FILE WATCHER ENABLED
    require("neo-tree").setup({
      enable_git_status = true,
      enable_diagnostics = true,

      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,   -- 🔥 THIS AUTO-REFRESHES FILES
      },
    })
  end,
}

