local config = require "bookmarks.config"

local M = {}

function M.load()
  local path = config.config.storage.path
  local data = {}
  if vim.uv.fs_access(path, "r") == 0 then
    local file = io.open(path, "r")
    if file then
      local content = file:read("*a")
      file:close()
      data = vim.json.decode(content) or {}
    end
  end

  return data
end

function M.save(bookmarks)
  local path = config.config.storage.path
  local content = vim.json.encode(bookmarks)
  local file = io.open(path, "w")
  if file then
    file:write(content)
    file:close()
  end
end

return M
