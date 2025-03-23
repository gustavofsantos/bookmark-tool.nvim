# Bookmarks Tool

This is a file bookmarking tool to keep track of important files in large codebases.

The design philosophy of this plugin is to solve the following problem.

> I need to work on several massive projects, where it's easy to lost track of where files are.
> so that with this plugin I can make annotations in multiple places in the same file and
> browse the annotations as bookmarks. Commiting my bookmarking file to a secure place is a must
> because I cannot depend on my working PC not failing.

## Usage

- **Create a new bookmark:**  
  Run `:NewBookmark Your bookmark description` to create a bookmark at the current cursor position, or simply `:NewBookmark` without a description.
- **Project search:**  
  Run `:ProjectBookmarks` to search bookmarks in the current working directory.
- **Global search:**  
  Run `:GlobalBookmarks` to search through all bookmarks.

When viewing bookmarks with Telescope:
- Press **Enter** to open the file at the saved line and column.
- Press **Ctrl-d** to delete the selected bookmark.
- Press **Ctrl-e** to edit the selected bookmark's description.

