return {
  {
    "wolandark/vim-piper",
    lazy = false,  -- Load the plugin immediately
    config = function()
      vim.g.piper_bin = '/usr/bin/piper-tts'
      vim.g.piper_voice = '/path/to/voice/model.onnx'
    end,
  },
}
