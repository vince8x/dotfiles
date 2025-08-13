return {
  {
    "eyalk11/speech-to-text.nvim",
  },
  {
    "kyza0d/vocal.nvim",
    event = "VeryLazy",
    cmd = { "Vocal" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("vocal").setup({
        -- API key (string, table with command, or nil to use OPENAI_API_KEY env var)
        api_key = nil,

        -- Directory to save recordings
        recording_dir = os.getenv("HOME") .. "/recordings",

        -- Delete recordings after transcription
        delete_recordings = true,

        -- Keybinding to trigger :Vocal (set to nil to disable)
        keymap = "<localleader>vv",

        -- Local model configuration (set this to use local model instead of API)
        --
        -- local_model = {
        --   model = "base",       -- Model size: tiny, base, small, medium, large
        --   path = "~/whisper",   -- Path to download and store models
        -- },

        -- API configuration (used only when local_model is not set)
        api = {
          model = "whisper-1",
          language = nil, -- Auto-detect language
          response_format = "json",
          temperature = 0,
          timeout = 60,
        },
      })
    end,
  },
}
