return{

  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',


    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },

      {
        "j-hui/fidget.nvim",
        config = true,
      },
    },
    config = function()
            require("plugins.configs.lspconfig")

    end
  },

	{
		"jose-elias-alvarez/null-ls.nvim",
        event ="VeryLazy",
        config = function ()
            require("plugins.configs.null-ls")
        end,
        lazy = true
	},

}
