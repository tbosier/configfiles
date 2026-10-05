vim.g.mapleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.keymap.set('n', '<leader>tt', ':belowright split | term<CR>', { noremap = true, silent = true })

vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true }) -- Esc leaves terminal mode
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window below' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window above' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

-- The cheat sheet: :Guide or <space>?
local guide = vim.fn.stdpath('config') .. '/guide/commands.md'
vim.api.nvim_create_user_command('Guide', function() vim.cmd.split(guide) end, { desc = 'Open my command guide' })
vim.keymap.set('n', '<leader>?', '<cmd>Guide<CR>', { desc = 'Open my command guide' })


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
require("vim-options")
require("lazy").setup("plugins")
