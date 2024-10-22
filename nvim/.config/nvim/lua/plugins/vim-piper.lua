return {
  {
    "wolandark/vim-piper",
    lazy = false, -- Load the plugin immediately
    config = function()
      vim.g.piper_bin = "/usr/bin/piper-tts"
      vim.g.piper_voice = (os.getenv("HOME") or "/home/vince8x")
        .. "/.local/share/piper-tts/voices/en_US-joe-medium.onnx"

      vim.keymap.set("n", "<localleader>tw", ":call SpeakWord()<CR>", { noremap = true, silent = true, desc = "Speak Word" })
      vim.keymap.set(
        "n",
        "<localleader>tc",
        ":call SpeakCurrentLine()<CR>",
        { noremap = true, silent = true, desc = "Speak Current Line" }
      )
      vim.keymap.set(
        "n",
        "<localleader>tp",
        ":call SpeakCurrentParagraph()<CR>",
        { noremap = true, silent = true, desc = "Speak Current Paragraph" }
      )
      vim.keymap.set(
        "n",
        "<localleader>tf",
        ":call SpeakCurrentFile()<CR>",
        { noremap = true, silent = true, desc = "Speak Current File" }
      )
      vim.keymap.set(
        "v",
        "<localleader>tv",
        ":call SpeakVisualSelection()<CR>",
        { noremap = true, silent = true, desc = "Speak Visual Selection" }
      )
    end,
  },
}
