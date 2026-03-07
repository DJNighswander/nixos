return {
  "yetone/avante.nvim",
  opts = {
    provider = "openrouter",
    providers = {
      ["openrouter-claude"] = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "anthropic/claude-sonnet-4.6",
      },
      ["openrouter-gemini"] = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "google/gemini-3-flash-preview",
      },
    },
    -- Force Avante to use its own internal logic for inputs
    -- This bypasses the buggy vim.ui.select call
    hints = { enabled = false },
  },
}
