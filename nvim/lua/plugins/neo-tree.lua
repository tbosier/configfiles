
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
     -- neo-tree will lazily load itself
    config = function() 
      vim.keymap.set('n', '<C-n>',':Neotree filesystem reveal left<CR>',{})
      vim.keymap.set('n','<leader>1', '<C-w>h', {desc= 'Focus NeoTree'})
      vim.keymap.set('n','<leader>2','<C-w>l', {desc = 'Focus code window'})
    end

}
