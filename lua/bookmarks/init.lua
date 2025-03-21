local M = {}

function M.setup(user_config)
  require("bookmarks.config").setup(user_config)
  require("bookmarks.commands").create_commands()
end

return M
