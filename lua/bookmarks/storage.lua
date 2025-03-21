local config = require "bookmarks.config"

local M = {}

function M.load()
  local path = config.config.storage.path
  local ok, bookmarks = pcall(dofile, path)

  if not ok then
    vim.notify("Failed to load bookmarks", vim.log.levels.ERROR)
    return {}
  end

  return bookmarks
end

function M.save(bookmarks)
  local path = config.config.storage.path
  local file, err = io.open(path, "w")
  if not file then
    vim.notify("Failed to save bookmarks: " .. err, vim.log.levels.ERROR)
    return false
  end

  file:write("-- Bookmarks file. You can edit this file manually.\nreturn {\n")
  for _, bm in ipairs(bookmarks) do
    file:write(string.format(
      "  { id = '%s', file = '%s', line = %d, col = %d, description = %q, project = '%s', timestamp = %d },\n",
      bm.id, bm.file, bm.line, bm.col, bm.description or "", bm.project, bm.timestamp))
  end
  file:write("}\n")
  file:close()
end

return M
