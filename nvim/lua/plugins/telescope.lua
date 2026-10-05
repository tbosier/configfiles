return  {
  {  'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
   local builtin = require("telescope.builtin")
   vim.keymap.set('n','<C-p>',builtin.find_files, {})
   vim.keymap.set('n','<leader>fg', builtin.live_grep, {})
   local function map(lhs, fn, desc) vim.keymap.set('n', lhs, fn, { desc = desc }) end
   map('<leader>ff', builtin.find_files, 'Find file by name')
   map('<leader>fw', builtin.grep_string, 'Grep word under cursor')
   map('<leader>fb', builtin.buffers, 'Open buffers')
   map('<leader>fo', builtin.oldfiles, 'Recent files')
   map('<leader>fh', builtin.help_tags, 'Search :help')
   map('<leader>fk', builtin.keymaps, 'Search all keymaps')
   map('<leader>fr', builtin.lsp_references, 'Where is this used')
   map('<leader>fs', builtin.lsp_document_symbols, 'Symbols in this file')
   map('<leader>fS', builtin.lsp_dynamic_workspace_symbols, 'Symbols in project')
   map('<leader>fd', builtin.diagnostics, 'Problems (fuzzy list)')
   map('<leader>f.', builtin.resume, 'Reopen last search')
  end
  },
  {
     "nvim-telescope/telescope-ui-select.nvim",
    config = function()
    -- This is your opts table
require("telescope").setup( {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- even more opts
      }
    }
  }
})
require("telescope").load_extension("ui-select")
    end

  }
}
