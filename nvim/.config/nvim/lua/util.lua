
local M = {}

local lsp_config = require("lspconfig")

function M.table_extend(dest, src)
  for k, v in pairs(src) do
    dest[k] = v
  end
end

function M.get_associative_values(table)
  local result = {}

  for k, v in pairs(table) do
    if type(k) ~= "number" then
      result[k] = v
    end
  end

  return result
end

-- https://www.reddit.com/r/neovim/comments/1bm5ms7/does_neovim_can_handle_both_deno_and_ts_lsp_in/la709a0/
function M.deepest_root_pattern(patterns1, patterns2)
  -- Create two root_pattern functions
  local find_root1 = lsp_config.util.root_pattern(unpack(patterns1))
  local find_root2 = lsp_config.util.root_pattern(unpack(patterns2))

  return function(startpath)
    local path1 = find_root1(startpath)
    local path2 = find_root2(startpath)

    if path1 and path2 then
      -- Count the number of slashes to determine the path length
      local path1_length = select(2, path1:gsub("/", ""))
      local path2_length = select(2, path2:gsub("/", ""))

      if path1_length > path2_length then
        return path1
      end

    elseif path1 then
      return path1
    end

    return nil
  end
end

return M
