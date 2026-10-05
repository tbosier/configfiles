return {
  -- Press <leader> (space) and wait: a popup lists every key that follows.
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "find (telescope)" },
      { "<leader>c", group = "code" },
      { "<leader>r", group = "rust" },
      { "<leader>x", group = "problems list (trouble)" },
      { "<leader>h", group = "git hunks" },
      { "<leader>i", group = "inlay hints" },
      { "<leader>t", group = "terminal" },
    },
  },
}
