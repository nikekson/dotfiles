local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local telescope_pickers = require("telescope.pickers")
local telescope_finders = require("telescope.finders")
local telescope_conf = require("telescope.config").values
local M = {}

M.SmartFocus = function(dir)
  local win = vim.fn.winnr()

  vim.cmd("wincmd " .. dir)

  -- Check if the same window is still the focused one (meaning that focus hasn't changed)...
  -- NOTE: I don't know if this is still necessary in recent versions of Neovim
  if win == vim.fn.winnr() then
    if dir == "h" then
      vim.cmd("tabprevious")
    elseif dir == "l" then
      vim.cmd("tabnext")
    end
  end

  -- ...Otherwise, we've focused another window in the split
end

return M
