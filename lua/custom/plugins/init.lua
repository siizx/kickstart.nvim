-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Undotree

  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle', -- 🔧 explicitly say this is a command we want to lazy-load on
    keys = {
      {
        '<leader>u',
        function()
          vim.cmd 'UndotreeToggle'
        end,
        desc = 'Toggle Undotree',
      },
    },
  },
  -- Harpoon
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():append()
      end, { desc = 'Harpoon add file' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon menu' })
      vim.keymap.set('n', '<C-h>', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<C-t>', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<C-n>', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<C-s>', function()
        harpoon:list():select(4)
      end)
    end,
  },
}
