return {
  "https://codeberg.org/ravnheim/project_notes",
  name = "project_notes",
  config = function()
    require("project_notes").setup({
      notes_path = ".notes",
      autosave = true,
      extension = ".md",
      sign = "󱞁",
      confirmation = true, -- confirm before deleting notes
      highlight = {
        fg = "#a0a0a0",
        bg = "#2e2e2e",
      },
      keymaps = {
        main = "<leader>nm",
        toggle = "<leader>nt",
        list = "<leader>nl",
        delete = "<leader>nd",
        delete_empty = "<leader>ne",
        merged = "<leader>nm",
      },
    })
  end,
}
