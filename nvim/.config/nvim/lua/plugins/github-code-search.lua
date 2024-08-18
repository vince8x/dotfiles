return { "napisani/nvim-github-codesearch", build = "make", keys = {
    {
      "<localleader>gs",
      function()
        local gh_search = require("nvim-github-codesearch")
        gh_search.prompt()
      end,
      desc = "Search code on GitHub",
    },
 },
  config = function()
    -- local token = vim.fn.system("gh auth token")
    local token = os.getenv("GITHUB_API_KEY")
    local gh_search = require("nvim-github-codesearch")

    ---@diagnostic disable-next-line: missing-fields
    gh_search.setup({
      github_auth_token = token,
      use_telescope = true,
    })
  end, }
