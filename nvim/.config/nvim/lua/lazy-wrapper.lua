-- This wrapper is not strictly needed, but it cleans up the code in init.lua a bit

return function(plugins)
  -- Bootstrap lazy.nvim {{
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  -- }}

  require("lazy").setup(plugins, {})
end
