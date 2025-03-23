local storage = require "bookmarks.storage"


local ID_LENGTH = 6

local function generate_id()
  local charset = {}
  for c = 48, 57 do table.insert(charset, string.char(c)) end  -- 0-9
  for c = 65, 90 do table.insert(charset, string.char(c)) end  -- A-Z
  for c = 97, 122 do table.insert(charset, string.char(c)) end -- a-z

  local id = ""
  for _ = 1, ID_LENGTH do
    local rand = math.random(#charset)
    id = id .. charset[rand]
  end
  return id
end

local M = {}

function M.get_project()
  return vim.fn.getcwd()
end

function M.new(opts)
  local pos = vim.api.nvim_win_get_cursor(0)

  local bookmark = {
    id = generate_id(),
    file = vim.fn.expand('%:p'),
    line = pos[1],
    col = pos[2],
    description = opts.description,
    timestamp = os.time(),
    project = M.get_project(),
  }

  local bookmarks = storage.load()
  print(vim.inspect(bookmarks))
  table.insert(bookmarks, bookmark)
  storage.save(bookmarks)

  return bookmark
end

function M.get_relative_file_path(bookmark)
  local project = M.get_project()
  local file = bookmark.file

  if file:find(project, 1, true) == 1 then
    return file:sub(#project + 2)
  end

  return file
end

function M.delete(id)
  local bookmarks = storage.load()

  for i, bookmark in ipairs(bookmarks) do
    if bookmark.id == id then
      table.remove(bookmarks, i)
      storage.save(bookmarks)
      return true
    end
  end

  return false
end

function M.update(id, opts)
  local bookmarks = storage.load()

  for _, bookmark in ipairs(bookmarks) do
    if bookmark.id == id then
      bookmark.description = opts.description or bookmark.description
      bookmark.file = opts.file or bookmark.file
      bookmark.line = opts.line or bookmark.line
      bookmark.col = opts.col or bookmark.col
      bookmark.timestamp = os.time()

      storage.save(bookmarks)
      return bookmark
    end
  end

  return false
end

function M.list()
  return storage.load()
end

return M
