-- Helpers
local function get_dir(filepath)
  return filepath:match("(.*/)")
end

local function cmd_async(str)
  vim.api.nvim_input(str)
end


local function is_array(t)
  if type(t) == "string" then return false end
  local i = 0
  for _ in pairs(t) do
    i = i + 1
    if t[i] == nil then return false end
  end
  return true
end

local M = {
  v = {},
  i = {},
  n = {},
  t = {},
  c = {},
  [""] = {}
}
local function map(mode, binding, action)
  if is_array(mode) then
    for _, m in ipairs(mode) do map(m, binding, action) end
    return
  end
  M[mode][binding] = action;
end


-- Comments
if not vim.g.neovide then
  --map("n", "<C-_>", "<cmd> :lua require('Comment.api').toggle.linewise.current()<CR>j")
  --map("v", "<C-_>", "<esc><cmd> :lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>")

  -- Ctrl+Shift+/ gives <BS> for some reason
  --map("n", "<BS>", "viw<esc><cmd> :lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<CR>j")
  --map("v", "<BS>", "<esc><cmd> :lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<CR>")
else
  map('n', '<C-_>', function ()
    
  end)
  --map("n", "<C-/>", "<cmd> :lua require('Comment.api').toggle.linewise()<CR>j")
  --map("v", "<C-/>", "<esc><cmd> :lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>")

  --map("n", "<C-?>", "viw<esc><cmd> :lua require('Comment.api').toggle_blockwise_op(vim.fn.visualmode())<CR>j")
  --map("v", "<C-?>", "<esc><cmd> :lua require('Comment.api').toggle_blockwise_op(vim.fn.visualmode())<CR>")
end

-- Wrap in quotes
-- map('v', "'", "c''<C-[>P");

-- move line with proper tabbing
map("n", "<c-a-j>", '$v^d"_ddoa<C-[>p^"_x')
map("n", "<c-a-k>", '$v^d"_ddkOa<C-[>p^"_x')

-- tree
map("n", "<a-1>", '<CMD>Neotree toggle<CR>')
-- map("n", "<a-w>", "<CMD>Neotree reveal<CR>")
map("n", "<a-w>", "<CMD>bd<CR>")
map("n", "<leader>e", "<CMD>Neotree reveal<CR>")


map("n", "<a-2>", ":DBUIToggle<CR>")

-- Tab close. TODO: ensure that this doesn't close nvim
map("n", "<C-w>", function ()
  local closed = require('neo-tree.sources.manager').close('filesystem')
  cmd_async("<leader>w:bd<CR>")
  if closed then
    -- cmd_async('<CMD>:Neotree reveal<CR>')
  end
end)
-- map("i", "<C-w>", "<C-[><C-w>:bd<CR>")

-- INPUT NAVIGATION IN EDIT MODE
map("i", "<C-w>", "<C-[>wi")
map('i', "<C-e>", "<C-[>ea")
map("i", "<C-b>", "<C-[>bi")

map('i', "<C-k>", "<Up>")
map('i', "<C-j>", "<Down>")
map('i', "<C-h>", "<Left>")
map('i', "<C-l>", "<Right>")





-- poor man's paste
map("n", "<C-v>", "<C-[>P")
map("i", "<C-v>", "<C-[>p")
map("t", "<C-v>", "<C-[>p")

-- What is dis? togoogle
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

-- Restores cursor after reopen
vim.cmd([[autocmd BufRead * call setpos(".", getpos("'\""))]])

if 'Change color on mode' and false then
  local color = nil
  vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    callback = function()
      vim.api.nvim_set_hl(0, "Normal", { bg = "#110000" })
    end
  })

  vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    callback = function()
      if not color then return end
      vim.api.nvim_set_hl(0, "Normal", { bg = "#001100" })
    end
  })
end

map({ "t" }, "hh", "<C-\\><C-n>")

-- horizontal window movement
map({ "n", "i" }, "<C-j>", "<C-w>h")
map({ "n", "i" }, "<C-k>", "<C-w>l")

map({ "n" }, "<leader>;w", "<cmd>w<CR>")
-- map({ "i" }, ":w<CR>", "<cmd>w<CR>")

map({ "n" }, "<C-[>", "<C-[>:w<CR>");
map({ "n" }, "<Esc>", "<C-[>:w<CR>");


-- map("i", "<C-q>", "<C-[>mmF(<C-q>")

-- horizontal window movement from input mode
map({ "i" }, "<C-j>", "<C-[><C-w>h")
map({ "i" }, "<C-k>", "<C-[><C-w>l")

-- vertical window movement
map({ "n", "i" }, "<C-h>", "<C-w>j")
map({ "n", "i" }, "<C-l>", "<C-w>k")

-- vertical window movement from input mode
map({ "i" }, "<C-h>", "<C-[><C-w>j")
map({ "i" }, "<C-l>", "<C-[><C-w>k")

-- Split vertically
map("", "<a-t>", "<C-w>v");


map("v", "<", "<gv")
map("v", ">", ">gv")

map("c", "<c-v>", "<c-r>*")


map("v", "J", "j")
map("v", "K", "k")

-- space->w to map for Ctrl+w
map("n", "<leader>w", "<C-w>")

-- insert line inplace
map({ "n", "v" }, "<C-o>", '"_ddO')

-- map("", '<C-j>', '<DOWN>')
-- map("", '<C-k>', '<UP>')

-- do not put to the register
M.n["x"] = '"_x'
M.n["X"] = '"_X'
M.n["d"] = '"_d'
M.n["D"] = '"_D'
M.v["x"] = 'd'
M.v["d"] = '"_d'

M.n['ce'] = '"_ce'
M.n['cw'] = '"_cw'
M.n['cb'] = '"_cb'
M.n['cW'] = '"_cW'
M.n['cB'] = '"_cB'
M.n['ciw'] = '"_ciw'
M.n['caw'] = '"_caw'
M.n['cc'] = '"_cc'
M.v['c'] = '"_c'


M.v['a('] = '"tdi()<C-[>"tP'
M.v['a{'] = '"tdi{}<C-[>"tP'


-- History jumps
map('n', '<S-h>', '<C-o>')
map('n', '<S-l>', '<C-i>')

-- Recent files
M.n["<C-e>"] = function() require("telescope.builtin").oldfiles() end

-- LSP things
map('', '<F2>', function() vim.lsp.buf.rename() end)
map('i', '<F2>', function() vim.lsp.buf.rename() end)
map('', '<C-q>', function() vim.lsp.buf.signature_help() end)
-- map('i', '<C-q>', function() 
  -- local keys = vim.api.nvim_replace_termcodes('<C-[>mmF(h<C-q>',true,false,true)
  -- vim.api.nvim_feedkeys(keys, 'm', false)
  -- vim.lsp.buf.signature_help()
-- end)
map('i', '<C-q>', function()
  vim.lsp.buf.hover()
end)
map('', '<M-CR>', function() vim.lsp.buf.code_action() end)
map('n', 'gi', function() vim.lsp.buf.implementation() end)

-- diagnostics
map('n', "<a-.>", function() 
  local x = vim.diagnostic.get_next()
  if not x then return end
  vim.diagnostic.jump({
    diagnostic = x
  })
end)
map('n', "<a-,>", function()
  local x = vim.diagnostic.get_prev()
  if not x then return end
  vim.diagnostic.jump({
    diagnostic = x
  })
end)
-- wrap selection



-- New file
map({ 'n', 'i' }, '<a-n>', function()
  local dir = get_dir(vim.fn.expand('%'))
  if dir == nil then
    dir = './'
  end
  vim.ui.input({ prompt = "Create file: ", default = dir, completion = "file" }, function(fname)
    if not fname then return end

    local target_dir = get_dir(fname)

    if not fname or not target_dir then return end

    cmd_async('<-[>:!mkdir -p ' .. target_dir .. '<CR>:e ' .. fname .. '<CR>:w<CR>')
  end)
end)


-- Terminal
-- map({ 'n', 'v', 'i' }, '<C-Space>', '<C-[><cmd>ToggleTerm size=10 direction=horizontal<cr>')
map({ 'n', 'v' }, '<C-Space>', '<C-[><cmd>ToggleTerm direction=float<cr>')
map({ 'n', 'v', 'i' }, '<M-Space>', '<C-[><cmd>ToggleTerm direction=float<cr>')
-- map('t', "<C-Space>", "<C-\\><C-n><cmd>ToggleTerm<cr>")
map('t', "<M-Space>", "<cmd>ToggleTerm<cr>")
map('t', "<C-Space>", "<cmd>ToggleTerm<cr>")
map('t', "<Esc>", "<C-\\><C-n><C-w>k")

-- map("n", "<leader>r", "<cmd>ToggleTerm direction=float<cr><C-c><CR><UP><CR><cmd>ToggleTerm<cr>")
map("n", "<leader>r", '<cmd>TermExec cmd="<C-c>"<CR><UP><CR>')

map("n", "<leader>pm", '<cmd>Mason<CR>')

return M

