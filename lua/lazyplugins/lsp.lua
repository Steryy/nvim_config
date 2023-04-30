return {
  { "jose-elias-alvarez/typescript.nvim", lazy = true },
  {
    "neovim/nvim-lspconfig",

    init = function()
      require("core.utils").lazy_load "nvim-lspconfig"
    end,
    cmd = { "LspInfo" },
    config = function()
      require "plugins.configs.lspconfig"
    end,
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "plugins.configs.null-ls"
        end,
      },

      {
        "j-hui/fidget.nvim",
        config = true,
      },
    },
  },
  { "nvim-lua/lsp-status.nvim", lazy = true },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    event = "VeryLazy",
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = true,
  },
  -- override plugin configs
}
