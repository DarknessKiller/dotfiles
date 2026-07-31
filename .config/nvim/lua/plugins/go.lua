return {
  {
    "neovim/nvim-lspconfig",
    ft = { "go" },
    config = function()
      vim.lsp.config("gopls", {
        root_markers = { "go.work", "go.mod", ".git" },
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            analyses = {
              unusedparams = true,
            },
          },
        },
      })

      vim.lsp.enable("gopls")
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gofumpt", "goimports" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    },
  },

  {
    "leoluz/nvim-dap-go",
    ft = { "go" },
    config = function()
      require("dap-go").setup()
    end,
  },
}
