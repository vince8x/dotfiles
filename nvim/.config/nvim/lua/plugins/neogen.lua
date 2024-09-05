return {
  "danymat/neogen",
  config = true,
  keys = {
    {
      "<leader>cn",
      function()
        require("neogen").generate({})
      end,
      desc = "Generate func|class|type documentation",
    },
  },
}
