local lazy = require("lazy-wrapper")
local options = require("options")
local plugins = require("plugins")
require("autocmd")

-- This needs to be set before calling `lazy()` {
vim.g.mapleader = " " -- This is <space>
vim.g.maplocalleader = " "
-- }

lazy(plugins) -- ** Prefer to load custom config after this line **

-- Modules that need to be loaded after lazy has been initialized {
local mappings = require("mappings")
local util = require("util")
-- }

require("kanagawa").setup({
  transparent = true,
  dimInactive = true,
  overrides = function(colors)
    local theme = colors.theme
    return {
      -- Block-like modern Telescope
      TelescopeTitle = { fg = theme.ui.special, bold = true },
      TelescopePromptNormal = { bg = theme.ui.bg_p1 },
      TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
      TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
      TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
      TelescopePreviewNormal = { bg = theme.ui.bg_dim },
      TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
    }
  end,
})

--vim.cmd[[colorscheme tokyonight]]
vim.cmd[[colorscheme kanagawa]]

local telescope_actions = require("telescope.actions")

local telescope_common_mappings = {
  n = {
    ["<C-j>"] = telescope_actions.move_selection_next,
    ["<C-k>"] = telescope_actions.move_selection_previous,
  },

  i = {
    ["<C-j>"] = telescope_actions.move_selection_next,
    ["<C-k>"] = telescope_actions.move_selection_previous,
  },
}

require("telescope").setup({
  pickers = {},

  defaults = {
    mappings = telescope_common_mappings,
  },
})

require("telescope-tabs").setup({})

require("Comment").setup {
  padding = true,
  sticky = true,
  ignore = nil,
  toggler = {
    line = "<leader>kk",
    block = "<leader>KK",
  },
  opleader = {
    line = "<leader>k",
    block = "<leader>K",
  },
  extra = {
    above = "<leader>kO",
    below = "<leader>ko",
    eol = "<leader>kA",
  },
  mappings = {
    basic = true,
    extra = true,
  },
  -- https://github.com/numToStr/Comment.nvim#-hooks
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
  post_hook = nil,
}

local treesitter_broken_indentation_languages = {
  "lua",
  "php",
  "rust",

  "jsx",
  "tsx",
  "javascriptreact",
  "typescriptreact",
}

require("nvim-treesitter.configs").setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "bash",
    "c",
    "cmake",
    "comment",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "glsl",
    "graphql",
    "html",
    "ini",
    "javascript",
    "jq",
    "json",
    "json5",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "meson",
    "perl",
    "php",
    "po",
    "python",
    "query",
    "regex",
    "rust",
    "scss",
    "sql",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "vue",
    "wgsl",
    "yaml",
  },

  indent = {
    enable = true,
    disable = treesitter_broken_indentation_languages,
  },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
}

require("lualine").setup {
  options = {
    theme = "tokyonight"
  }
}

require("barbecue").setup {
  theme = "tokyonight"
}

require("tokyonight").setup {
  style = "moon",

  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    sidebars = "dark",
    floats = "dark",
  },
}

require("colorizer").setup()
require("nvim-ts-autotag").setup()

require("marks").setup({
  default_mappings = true,
})

require("nvim-tree").setup()
require("inc_rename").setup()

local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.set_sign_icons({
  error = "✘",
  warn = "▲",
  hint = "⚑",
  info = "»",
})

lsp_zero.extend_lspconfig({
  manage_nvim_cmp = {
    set_sources = 'lsp',
    set_basic_mappings = true,
    set_extra_mappings = false,
    use_luasnip = true,
    set_format = true,
    documentation_window = true,
  },
})

local mason_ignore_language_servers = {
  -- rust-analyzer is set up by rust-tools
  -- clangd is set up manually with clangd_extensions

  --"pyright",
  "basedpyright",

  "tsserver", -- configured manually
}

local mason_ensure_installed = {
  "tsserver",
  "pyright",
  --"basedpyright",
  "lua_ls",
  "rust_analyzer",
  "clangd",
  "astro-language-server",
  "tailwindcss",
}

-- Utility functions (TODO: Move these to their own file) {
function map_list_values(list, value)
  local result = {}

  for _, v in pairs(list) do
    result[v] = value
  end

  return result
end

function shallow_merge(...)
  local result = {}

  for i = 1, select("#", ...) do
    local tbl = select(i, ...)

    if type(tbl) ~= "table" then
      error("All arguments must be tables")
    end

    for key, value in pairs(tbl) do
      result[key] = value
    end
  end

  return result
end
-- }

require('mason').setup({})
require('mason-lspconfig').setup({
  mason_ensure_installed = mason_ensure_installed,

  handlers = shallow_merge(
    {
      lsp_zero.default_setup,

      lua_ls = function()
        local lua_opts = lsp_zero.nvim_lua_ls()
        require('lspconfig').lua_ls.setup(lua_opts)
      end,
    },
    map_list_values(mason_ignore_language_servers, lsp_zero.noop)
  ),
})


local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local cmp_select = {
  behavior = cmp.SelectBehavior.Select,
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "luasnip" },
    { name = "cmp_luasnip" },
  },
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

    ["<Tab>"] = cmp_action.luasnip_jump_forward(),
    ["<S-Tab>"] = cmp_action.luasnip_jump_backward(),
  },
})

local lsp_config = require("lspconfig")

lsp_config.gleam.setup({
  capabilities = capabilities,
})

lsp_config.ts_ls.setup({
  capabilities = capabilities,

  -- NOTE: Required so it doesn't interfere with denols {
  root_dir = util.deepest_root_pattern(
    {"package.json", "tsconfig.json"},
    {"deno.json", "deno.jsonc", "import_map.json"}
  ),
  single_file_support = false,
  -- }

  init_options = {
    preferences = {
      -- Enable auto-import path aliases (e.g. instead of importing `./components/Component.tsx`, it imports `@/components/Component.tsx`)
      importModuleSpecifierPreference = "non-relative",
    }
  },
})

lsp_config.denols.setup({
  -- NOTE: Required so it doesn't interfere with ts_ls {
  root_dir = util.deepest_root_pattern(
    {"deno.json", "deno.jsonc", "import_map.json"},
    {"package.json", "tsconfig.json"}
  ),
  -- }
})

require("clangd_extensions").setup({
  capabilities = capabilities,
  inlay_hints = {
    inline = 0,
  }
})

vim.diagnostic.config({
  virtual_text = true,
})

local rust_tools = require("rust-tools")

rust_tools.setup({ capabilities = capabilities })


require ("lsp_signature").setup({
  bind = true,
  handler_opts = {
    border = "rounded"
  }
})

-- TODO: Move these functions to some other file

local function lsp_definition_tab()
  -- Get the current buffer's language server client
  local client_id = vim.lsp.buf_get_clients()[1].id

  -- Get the position under the cursor
  local position = vim.api.nvim_win_get_cursor(0)

  -- Send a "textDocument/definition" request to the language server
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(),
    position = {
      line = position[1] - 1,
      character = position[2]
    }
  }
  vim.lsp.buf_request(client_id, "textDocument/definition", params, function(_, result)
    -- If there is no definition, print an error message
    if not result or vim.tbl_isempty(result) then
      print("No definition found")
      return
    end

    vim.cmd("tabnew")

    local offset_encoding = vim.lsp.get_client_by_id(client_id).config.capabilities.offsetEncoding[1]

    -- Open the definition in the new tab
    vim.lsp.util.jump_to_location(result[1], offset_encoding)
  end)
end

local function split_lines()
  -- `getpos()` returns an array: [bufnum, lnum, col, off]
  local start_line = vim.fn.getpos("v")[2]
  local end_line = vim.fn.getpos(".")[2]

  -- Handle selections that were made "backwards"
  if start_line > end_line then
    end_line, start_line = start_line, end_line
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  local all_lines = {}
  for _, line in ipairs(lines) do
    local split = vim.split(line, " ", { trimempty = false })
    for _, l in ipairs(split) do
      table.insert(all_lines, l)
    end
  end

  -- delete the original line(s)
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {})

  -- put the text to the buffer
  vim.api.nvim_put(all_lines, "l", false, false)
end

-- TODO: Move these to mappings.lua
-- Open definition in new tab
vim.keymap.set("n", "gT", lsp_definition_tab)
vim.keymap.set("n", "<leader>s", split_lines)
vim.keymap.set("v", "<leader>s", split_lines)

for mode, list in pairs(mappings) do
  for key, mapping in pairs(list) do
    local func = mapping[1]
    -- `mapping` is a table that can be used to store additional data, such as a `desc = ` field for which-key.nvim
    local opts = util.get_associative_values(mapping)

    vim.keymap.set(mode, key, func, opts)
  end
end

for table, opts in pairs(options) do
  util.table_extend(vim[table], opts)
end
