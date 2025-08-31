-- This can be used instead of setting vim.opt.<x> and vim.g.<x> directly
-- Note that nil values are silently dropped by lua

return {
  opt = {
    mouse = "",

    number = true,
    relativenumber = true,

    clipboard = "unnamedplus",

    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    copyindent = true,
    autoindent = true,

    termguicolors = true,

    cindent = true,
    cinoptions = "g0,l1,L0",

    incsearch  = true,
    hlsearch   = true,
    ignorecase = true,
    smartcase  = true,

    -- Stop vim from splitting long lines when typing
    textwidth = 0,
    wrapmargin = 0,

    -- Open splits below or to the right of the current buffer
    splitright = true,
    splitbelow = true,

    -- Load custom 'insert-only-caps' keymap and disable it by default
    imsearch = -1,
    iminsert = 0,
    keymap = "insert-only-caps",
  },

  g = {
    -- Disable netrw (for nvim-tree)
    loaded_netrw = 1,
    loaded_netrwPlugin = 1,
  }
}
