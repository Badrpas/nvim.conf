local vscode = require 'vscode'

local function get_dir(filepath)
  return filepath:match '(.*/)'
end

local function cmd_async(str)
  vim.api.nvim_input(str)
end

local function is_array(t)
  if type(t) == 'string' then
    return false
  end
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then
      return false
    end
  end
  return true
end

local M = {
  v = {},
  i = {},
  n = {},
  t = {},
  x = {},
  [''] = {},
}
local function map(mode, binding, action)
  if is_array(mode) then
    for _, m in ipairs(mode) do
      map(m, binding, action)
    end
    return
  end
  M[mode][binding] = action
end

-- For my Ctrl skills are lacking -_-
--map('i', '[:w<CR>', '<C-[>:w<CR>')

-- multiple cursors
-- map('n', '<C-d>', '<C-n>')
-- map('v', '<C-d>', '<C-n>')
-- map('', '<C-d>', '<C-n>')
-- map('n', '<a-d>', '<C-d>')

map({ 'n', 'v' }, '<C-/>', function()
  vscode.call 'editor.action.commentLine'
  vim.api.nvim_feedkeys('j', 'n', false)
end)

vim.keymap.set({ 'n', 'x', 'i' }, '<C-d>', function()
  vscode.with_insert(function()
    vscode.action 'editor.action.addSelectionToNextFindMatch'
  end)
end)

map({ 'n' }, '<leader>lf', function()
  vscode.call 'editor.action.formatDocument'
end)

map('n', '<leader>lr', vim.lsp.buf.rename)

-- Execute a code action, usually your cursor needs to be on top of an error
-- or a suggestion from your LSP for this to activate.
map({ 'n', 'x' }, '<leader>la', vim.lsp.buf.code_action)

-- WARN: This is not Goto Definition, this is Goto Declaration.
--  For example, in C this would take you to the header.
map('n', 'gD', vim.lsp.buf.declaration)

-- Wrap in quotes
--map('v', "'", "c''<C-[>P")

-- tree
--map('n', '<leader>t', '<cmd>Neotree toggle<CR>')
--if vim.g.neovide then
--map('n', '<D-w>', '<cmd>Neotree reveal<CR>')
--map('n', '<D-1>', '<cmd>Neotree toggle<CR>')
--else
--map('n', '<a-w>', '<cmd>Neotree reveal<CR>')
--end
--map('n', '<leader>e', '<cmd>Neotree reveal<CR>')

-- Tab close. TODO: ensure that this doesn't close nvim
-- map('n', '<C-w>', '<CMD>:Neotree close<CR><C-w>:bd<CR>')
-- map('i', '<C-w>', '<C-[><C-w>:bd<CR>')

-- poor man's insert
map('n', '<C-v>', '<C-[>P')
map('i', '<C-v>', '<C-[>p')

-- What is dis? togoogle
vim.cmd 'autocmd BufEnter * set formatoptions-=cro'
vim.cmd 'autocmd BufEnter * setlocal formatoptions-=cro'

-- Restores cursor after reopen
vim.cmd [[autocmd BufRead * call setpos(".", getpos("'\""))]]

--map({ 'n', 'v' }, '<leader>r', '<C-[><cmd>ToggleTerm direction=float<cr><c-c><up><cr><cmd>ToggleTerm direciton=float<cr>')

--map({ 't' }, 'hh', '<C-\\><C-n>')

-- horizontal window movement
map({ 'n', 'i' }, '<C-j>', '<C-w>h')
map({ 'n', 'i' }, '<C-k>', '<C-w>l')

map({ 'n' }, '<leader>;w', '<cmd>w<CR>')
-- map({ "i" }, ":w<CR>", "<cmd>w<CR>")

map({ 'n' }, '<C-[>', '<C-[>:w<CR>')

-- horizontal window movement from input mode
map({ 'i' }, '<C-j>', '<C-[><C-w>h')
map({ 'i' }, '<C-k>', '<C-[><C-w>l')

-- vertical window movement
map({ 'n', 'i' }, '<C-h>', '<C-w>j')
map({ 'n', 'i' }, '<C-l>', '<C-w>k')

-- vertical window movement from input mode
map({ 'i' }, '<C-h>', '<C-[><C-w>j')
map({ 'i' }, '<C-l>', '<C-[><C-w>k')

map({ 'n' }, '<C-j>', function()
  vscode.call 'workbench.action.focusLeftGroup'
end)
map({ 'n' }, '<C-k>', function()
  vscode.call 'workbench.action.focusRightGroup'
end)
map({ 'n' }, '<C-h>', function()
  vscode.call 'workbench.action.focusBelowGroup'
end)
map({ 'n' }, '<C-l>', function()
  vscode.call 'workbench.action.focusAboveGroup'
end)

map({ 'n' }, 'K', {
  function()
    vscode.call 'workbench.action.nextEditorInGroup'
  end,
  desc = 'Next buffer',
})
map({ 'n' }, 'J', {
  function()
    vscode.call 'workbench.action.previousEditorInGroup'
  end,
  desc = 'Previous buffer',
})

map('v', '<', '<gv')
map('v', '>', '>gv')

map('v', 'J', 'j')
map('v', 'K', 'k')

-- space->w to map for Ctrl+w
map('n', '<leader>w', '<C-w>')

-- insert line inplace
map({ 'n', 'v' }, '<C-o>', '"_ddO')

-- map("", '<C-j>', '<DOWN>')
-- map("", '<C-k>', '<UP>')

-- do not put to the register
M.n['x'] = '"_x'
M.n['X'] = '"_X'
M.n['d'] = '"_d'
M.n['D'] = '"_D'
M.v['x'] = 'd'
M.v['d'] = '"_d'

M.n['ce'] = '"_ce'
M.n['cw'] = '"_cw'
M.n['cb'] = '"_cb'
M.n['cW'] = '"_cW'
M.n['cB'] = '"_cB'
M.n['ciw'] = '"_ciw'
M.n['caw'] = '"_caw'
M.n['cc'] = '"_cc'
M.v['c'] = '"_c'

-- config related
map('n', '\\e', ':!gnome-terminal --working-directory ~/.config/nvim/lua --window -- nvim user/mappings.lua<CR>')
map('n', '\\r', function()
  --require('user.custom.reload').ReloadConfig()
end)

-- History jumps
map('n', '<S-h>', '<C-o>')
map('n', '<S-l>', '<C-i>')

-- Recent files
M.n['<C-e>'] = function()
  require('telescope.builtin').oldfiles()
end

-- LSP things
map('', '<F2>', function()
  vim.lsp.buf.rename()
end)
map('i', '<F2>', function()
  vim.lsp.buf.rename()
end)
map('', '<C-q>', function()
  vim.lsp.buf.hover()
end)
map('', '<M-CR>', function()
  vim.lsp.buf.code_action()
end)
map('n', 'gi', function()
  vim.lsp.buf.implementation()
end)

-- diagnostics
map('n', '<a-.>', function()
  vim.diagnostic.goto_next()
end)
map('n', '<a-,>', function()
  vim.diagnostic.goto_prev()
end)

-- New file
map({ 'n', 'i' }, '<a-n>', function()
  local dir = get_dir(vim.fn.expand '%')
  if dir == nil then
    dir = './'
  end
  vim.ui.input({ prompt = 'Create file: ', default = dir, completion = 'file' }, function(fname)
    if not fname then
      return
    end

    local target_dir = get_dir(fname)

    if not fname or not target_dir then
      return
    end

    cmd_async('<-[>:!mkdir -p ' .. target_dir .. '<CR>:e ' .. fname .. '<CR>:w<CR>')
  end)
end)

-- Terminal
map({ 'n', 'v', 'i' }, '<C-Space>', '<C-[><cmd>ToggleTerm direction=float<cr>')
--map({ 'n', 'v', 'i' }, '<alt-Space>', '<C-[><cmd>ToggleTerm direction=float<cr>')
-- map('t', "<C-Space>", "<C-\\><C-n><cmd>ToggleTerm<cr>")
map('t', '<C-Space>', '<cmd>ToggleTerm<cr>')
map('t', '<Esc>', '<C-\\><C-n><C-w>k')

-- cmd chortcuts
map('n', '\\w', '<cmd>w<cr>')

map('n', '<leader>pm', { '<cmd>Mason<cr>', desc = '[P]ackages [M]ason' })

map('n', '§', '`')
map('n', '±', '~')
map('v', '§', '`')
map('v', '±', '~')
map('i', '§', '`')
map('i', '±', '~')

map('n', '<leader>bk', { '<cmd>bprev<CR><cmd>vert sbnext<CR>', desc = '[B]uffers Split To Right' })
map('n', '<leader>bb', { '<cmd>BufferPick<CR>', desc = '[B]uffers [B]e Select from tabline' })

return M



