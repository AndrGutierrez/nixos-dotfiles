-- GitHub theme for LazyVim (projekt0n/github-nvim-theme).
-- LazyVim picks the colorscheme up through its own opts, and the plugin is
-- loaded eagerly so the scheme exists when LazyVim applies it.
return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        options = {
          compile = false, -- let lazy.nvim manage the plugin
          transparent = false,
        },
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_dark_default",
    },
  },
}
