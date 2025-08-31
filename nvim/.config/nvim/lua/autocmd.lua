local general_settings_group = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })
local ansible_settings_group = vim.api.nvim_create_augroup("AnsibleSettings", { clear = true })

-- NOTE: Use this function instead of calling `vim.fn.expand()` directly,
--       as the latter also expands other characters like '*'
local expand_home = function(path)
  local parts = vim.split(path, "/")

  if vim.startswith(parts[1], "~") then
    parts[1] = vim.fn.expand(parts[1])
  end

  return table.concat(parts, "/")
end

vim.api.nvim_create_autocmd({"InsertLeave", "VimEnter", "BufRead", "BufNewFile"}, {
  pattern = {"*"},
  command = "set iminsert=0",
  group = general_settings_group,
})
vim.api.nvim_create_autocmd({"FileType"}, {
  pattern = {"TelescopePrompt"},
  command = "set iminsert=0",
  group = general_settings_group,
})


vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"Dockerfile", "Dockerfile.*"},
  command = "setfiletype Dockerfile",
  group = general_settings_group,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  -- Inkscape extension files
  pattern = "*.inx",
  command = "setfiletype xml",
  group = general_settings_group,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  -- Prevents vim from leaking potentially sensitive information when editing Ansible secrets
  pattern = {
    "*ansible/*.{yml,yaml}",
  },
  command = "setlocal noswapfile nobackup nowritebackup viminfo= clipboard=",
  group = ansible_settings_group,
})
