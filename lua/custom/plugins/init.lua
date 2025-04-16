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

  -- Harpoon with fzf integration
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-fzf-native.nvim', -- fzf native extension
    },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()

      -- Basic Harpoon keymaps
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Harpoon add current file' })

      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon menu' })

      -- Quick access to harpooned files
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

      vim.keymap.set('n', '<leader>ff', function()
        local builtin = require 'telescope.builtin'
        local actions = require 'telescope.actions'
        local action_state = require 'telescope.actions.state'
        local utils = require 'telescope.utils'

        builtin.find_files {
          cwd = vim.fn.expand '~', -- or utils.find_git_root()
          find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' },
          layout_strategy = 'vertical',
          layout_config = { height = 0.9 },
          previewer = false,
          attach_mappings = function(_, map)
            actions.select_default:replace(function(prompt_bufnr)
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                require('harpoon'):list():add(selection.path or selection.value)
                vim.cmd('edit ' .. vim.fn.fnameescape(selection.path or selection.value))
              end
            end)
            return true
          end,
        }
      end, { desc = 'Find file from ~ and add to Harpoon' })

      -- Optional: Add selected file to Harpoon automatically
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TelescopeFindFilePost',
        callback = function()
          local selection = require('telescope.actions.state').get_selected_entry()
          if selection then
            require('harpoon.mark').add_file(selection.value)
          end
        end,
      })
    end,
  },
}
