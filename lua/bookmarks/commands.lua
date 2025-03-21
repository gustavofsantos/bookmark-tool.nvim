local picker = require "bookmarks.picker"
local core = require "bookmarks.core"

local M = {}

function M.cmd_new(opts)
  local description = opts.args or ""

  if description:match("^description=") then
    description = description:gsub("^description=", "")
    description = description:gsub('^"(.*)"$', "%1")
  end

  core.new({
    description = description,
  })
end

function M.scoped_list()
  local scoped = {}
  local project = core.get_project()
  local bookmarks = core.list()

  for _, bookmark in ipairs(bookmarks) do
    if vim.startswith(bookmark.project, project) then
      local relative_path = core.get_relative_file_path(bookmark)
      bookmark.file = relative_path
      table.insert(scoped, bookmark)
    end
  end

  return scoped
end

function M.scoped_search()
  local bookmarks = M.scoped_list()
  local function on_mutate()
    picker.telescope_picker(M.scoped_list())
  end

  picker.telescope_picker(bookmarks, on_mutate)
end

function M.search()
  local bookmarks = M.list()
  local function on_mutate()
    picker.telescope_picker(M.scoped_list())
  end

  picker.telescope_picker(bookmarks, on_mutate)
end

function M.create_commands()
  vim.api.nvim_create_user_command("NewBookmark", M.cmd_new, { nargs = "?" })
  vim.api.nvim_create_user_command("GlobalBookmarks", M.search, { nargs = "?" })
  vim.api.nvim_create_user_command("ProjectBookmarks", M.scoped_search, { nargs = "?" })
end

return M
