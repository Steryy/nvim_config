local get_icon = require("core.utils").get_icon
local options = {
  filters = {
    dotfiles = false,
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 30,
    preserve_window_proportions = true,
  },
  git = {
    enable = false,
    ignore = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    highlight_git = false,
    highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },

      glyphs = {
        default = get_icon("DefaultFile"),
        symlink = get_icon("SymLinkFile"),
        folder = {
          default = get_icon("FolderClosed"),
          empty = get_icon("FolderClosed"),
          empty_open = get_icon("FolderEmpty"),
          open =get_icon("FolderOpen"),
          symlink =get_icon("Symlink"),
          symlink_open = get_icon("SymlinkOpen"),
          arrow_open = get_icon("FoldOpened"),
          arrow_closed = get_icon("FoldClosed"),
        },
        git = {
          unstaged = get_icon("GitUnstaged"),
          staged = get_icon("GitStaged"),
          unmerged =get_icon("GitUnmerged"),
          renamed = get_icon("GitRenamed"),
          untracked = get_icon("GitUntracked"),
          deleted = get_icon("GitDelete"),
          ignored = get_icon("GitIgnored"),
        },
      },
    },
  },
}

return options
