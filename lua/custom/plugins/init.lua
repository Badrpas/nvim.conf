-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
return {
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        init = function()
            vim.g.barbar_auto_setup = false
            local map = vim.api.nvim_set_keymap
            local opts = { noremap = true, silent = true }
            map('n', 'J', '<cmd>BufferPrevious<cr>', opts)
            map('n', 'K', '<cmd>BufferNext<cr>', opts)

            map('n', '<c-w>', '<cmd>BufferClose<cr>', opts)
            map('i', '<c-w>', '<c-[><cmd>BufferClose<cr>', opts)
            map('v', '<c-w>', '<c-[><cmd>BufferClose<cr>', opts)

            vim.api.nvim_del_keymap('n', '<C-W>d')
            vim.api.nvim_del_keymap('n', '<C-W><C-D>')
        end,
        opts = {
            -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
            -- animation = true,
            -- insert_at_start = true,
            -- …etc.
            highlight_altername = false,
            highlight_visible = false,
            insert_at_end = true,
        },
        -- version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },

}
