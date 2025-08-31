-- TODO: Allow descriptions to be set with `["C-t"] = { "<cmd>tabnew<cr>", desc = "... " }`

local funcs = require("functions")
local telescope = require("telescope.builtin")
local telescope_tabs = require("telescope-tabs")

return {
  n = {
    ["<C-t>"] = { "<cmd>tabnew<cr>" },

    -- Clear search highlight
    ["\\/"] = { "<cmd>nohlsearch<cr>" },

    -- Split & tab rearrangement
    ["<C-M-h>"] = { "<cmd>tabmove -1<cr>" },
    ["<C-M-l>"] = { "<cmd>tabmove +1<cr>" },

    -- Make Y behave consistently with D, C, etc.
    -- Neovim seems to set this now by default, but it's still nice to have this here
    ["Y"] = { "y$" },

    --" Smart split & tab navigation
    ["<C-h>"] = { function() funcs.SmartFocus("h") end },
    ["<C-j>"] = { function() funcs.SmartFocus("j") end },
    ["<C-k>"] = { function() funcs.SmartFocus("k") end },
    ["<C-l>"] = { function() funcs.SmartFocus("l") end },

    -- Move lines
    ["<A-j>"] = { "<cmd>move +1<cr>" },
    ["<A-k>"] = { "<cmd>move -2<cr>" },

    ["<leader>f"] = { telescope.find_files },
    ["<leader>b"] = { telescope.buffers },
    ["<leader>w"] = { telescope_tabs.list_tabs },

    ["<leader>r"] = { telescope.lsp_references },
    ["<leader>i"] = { telescope.lsp_incoming_calls },
    ["<leader>o"] = { telescope.lsp_outgoing_calls },

    ["<C-p>"] = { telescope.live_grep },

    -- Select previously pasted text
    ["<leader>p"] = { "`[v`]" },

    -- Autotype :%s//g and move the cursor between the slashes (useful for search-n-replacing)
    ["\\s"] = {
      function()
        local sequence = ":%s//g<left><left>"
        local string = vim.api.nvim_replace_termcodes(sequence, false, false, true)
        vim.api.nvim_feedkeys(string, "n", false)
      end
    },

    ["T"] = { "<cmd>Trouble<cr>" },

    ["gp"] = { vim.diagnostic.goto_prev },
    ["gn"] = { vim.diagnostic.goto_next },
    ["gf"] = { vim.lsp.buf.code_action },

    ["<leader>h"] = { "<cmd>ClangdSwitchSourceHeader<cr>" },

    ["<leader><leader>"] = {
      function()
        local line = vim.api.nvim_get_current_line()
        local url = string.match(line, "[a-z]*://[^ >,;]*")

        if not url then
          error("No URL found in line")
          return
        end

        -- TODO(Nikekson): Shell-escape `url`
        os.execute("firefox '" .. url .. "'")

        vim.cmd[[norm 0d$]]
        vim.cmd[[norm j]]
      end
    },

    ["<leader>t"] = { "<cmd>NvimTreeToggle<cr>" },

    ["<leader>R"] = {
      function()
        vim.api.nvim_feedkeys(":IncRename " .. vim.fn.expand("<cword>"), "n", false)
      end
    },
  },

  i = {
    -- Toggle caps with C-c
    ["<C-c>"] = { "<C-^>" },
  },

  x = {
    ["ga"] = { "<Plug>(EasyAlign)" },
  },

  v = {
    -- Stay in visual mode when indenting
    ["<"] = { "<gv", silent = true },
    [">"] = { ">gv", silent = true },
  },
}
