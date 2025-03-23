local M = {}

local defaults = {
  storage = {
    path = vim.fn.stdpath('data') .. '/bookmarks.json',
  },
}

M.config = {}

function M.setup(user_config)
  M.config = vim.tbl_deep_extend("force", defaults, user_config or {})
  return M.config
end

return M
