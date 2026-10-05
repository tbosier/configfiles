return {
  -- A "Problems" panel: every diagnostic the language servers have reported, jumpable.
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {},
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "All reported problems" },
    { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Problems in this file" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Outline (structs, fns)" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
  },
}
