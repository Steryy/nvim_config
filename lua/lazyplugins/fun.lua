return {

  { "ThePrimeagen/vim-be-good", lazy = true, cmd = { "VimBeGood" } },
  {
    "alec-gibson/nvim-tetris",
    lazy = true,
    cmd = { "Tetris" },
  },
  {
    "seandewar/killersheep.nvim",
    lazy = true,
    cmd = { "KillKillKill" },
  },
  {
    "Eandrju/cellular-automaton.nvim",
    cmd = { "CellularAutomaton" },
    config = function()
        require("plugins.configs.cellular-automaton")
    end,
  },
}
