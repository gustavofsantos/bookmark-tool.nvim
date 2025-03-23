local config = require "bookmarks.config"

local M = {}

function M.load()
  local path = config.config.storage.path
  if vim.fn.filereadable(path) == 0 then
    return {}
  end

  local file = io.open(path, "r")
  if not file then
    return {}
  end

  local content = file:read("*a")
  file:close()
  return vim.json.decode(content) or {}
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
