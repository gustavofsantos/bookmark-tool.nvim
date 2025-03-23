local M = {}

function M.format_entry(bookmark)
  local file = bookmark.file
  local line = bookmark.line
  local description = bookmark.description or ""

  local display = ""
  if description == "" then
    display = string.format("%s:%d", file, line)
  else
    display = string.format("%s %s:%d", description, file, line)
  end

  return display
end

function M.telescope_picker(bookmarks, on_mutate)
  local has_telescope, _ = pcall(require, 'telescope')
  if not has_telescope then
    error('This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)')
  end

  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values

  pickers.new({}, {
    prompt_title = "Bookmarks",
    finder = finders.new_table {
      results = bookmarks,
      entry_maker = function(entry)
        local display = M.format_entry(entry)
        return {
          value = entry,
          display = display,
          ordinal = display,
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      local core = require('bookmarks.core')

      local function delete_entry()
        local id = action_state.get_selected_entry().value.id
        core.delete(id)

        if not on_mutate then
          return actions.close(prompt_bufnr)
        end

        return on_mutate()
      end

      local function edit_entry()
        local entry = action_state.get_selected_entry()
        local bookmark = entry.value
        local new_description = vim.fn.input("New description: ", bookmark.description)
        core.update(bookmark.id, { description = new_description })

        if not on_mutate then
          return actions.close(prompt_bufnr)
        end

        return on_mutate()
      end

      map('i', '<C-d>', delete_entry)
      map('n', '<C-d>', delete_entry)
      map('i', '<C-e>', edit_entry)
      map('n', '<C-e>', edit_entry)

      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local bookmark = selection.value

        vim.cmd(string.format("edit %s", bookmark.file))
        vim.api.nvim_win_set_cursor(0, { bookmark.line, bookmark.col })
      end)
      return true
    end,
  }):find()
end

return M
