return {
  -- Git changes in the gutter, plus jump/preview/stage/undo per change ("hunk").
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("n", "]h", function() gs.nav_hunk("next") end, "Next git change")
      map("n", "[h", function() gs.nav_hunk("prev") end, "Previous git change")
      map("n", "<leader>hp", gs.preview_hunk, "Preview change")
      map("n", "<leader>hs", gs.stage_hunk, "Stage change")
      map("n", "<leader>hr", gs.reset_hunk, "Undo change (reset hunk)")
      map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Who wrote this line")
    end,
  },
}
