local mappings = require 'mappings_vscode'
require('vscode').notify 'top kek'

for mode, v in pairs(mappings) do
  for binding, action in pairs(v) do
    if type(action) == 'table' then
      vim.keymap.set(mode, binding, action[1], { desc = action.desc })
    else
      vim.keymap.set(mode, binding, action)
    end
  end
end

print 'initialized'


