return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- This stops the LSP from trying to format "as you type"
      -- which is usually what causes that sudden bracket jump.
      format_on_type = false,
      setup = {
        rust_analyzer = function(_, opts)
          -- If you use the Rust extra, you can also tweak 
          -- rust-analyzer specific settings here
          opts.settings = {
            ["rust-analyzer"] = {
              format = { enable = false }, -- Let conform.nvim handle formatting instead
            },
          }
        end,
      },
    },
  },
}
