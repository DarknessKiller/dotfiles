return {
  {
    "nitinbhat972/cwal.nvim",
    lazy = false,      -- must load immediately
    priority = 1000,   -- load before everything else

    config = function()
      require("cwal").setup({
        auto_reload = true,
      })

      vim.cmd.colorscheme("cwal")
    end,
  },
}
