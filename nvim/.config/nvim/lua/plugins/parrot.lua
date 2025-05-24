return {
  "frankroeder/parrot.nvim",
  dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
  -- optionally include "folke/noice.nvim" or "rcarriga/nvim-notify" for beautiful notifications
  config = function()
    require("parrot").setup({
      -- Providers must be explicitly added to make them available.
      providers = {
        anthropic = {
          api_key = os.getenv("ANTHROPIC_API_KEY"),
        },
        gemini = {
          api_key = os.getenv("GEMINI_API_KEY"),
          models = {
            "gemini-2.5-flash-preview-04-17",
            "gemini-2.5-pro-preview-05-06",
          },
        },
        groq = {
          api_key = os.getenv("GROQ_API_KEY"),
        },
        mistral = {
          disable = true, -- Disable if not installed or not in PATH
          api_key = os.getenv("MISTRAL_API_KEY"),
        },
        pplx = {
          disable = true, -- Disable if not installed or not in PATH
          api_key = os.getenv("PERPLEXITY_API_KEY"),
        },
        -- provide an empty list to make provider available (no API key required)
        openai = {
          api_key = os.getenv("OPENAI_API_KEY"),
        },
        github = {
          api_key = os.getenv("GITHUB_TOKEN"),
        },
        nvidia = {
          disable = true, -- Disable if not installed or not in PATH
          api_key = os.getenv("NVIDIA_API_KEY"),
        },
        xai = {
          disable = true, -- Disable if not installed or not in PATH
          api_key = os.getenv("XAI_API_KEY"),
        },
        openrouter = {
          disable = false,
          style = "openai",
          endpoint = "https://openrouter.ai/api/v1/chat/completions",
          api_key = os.getenv("OPENROUTER_API_KEY"),
          models = {
            "openai/o1-mini-2024-09-12",
            "openai/o1-preview-2024-09-12",
            "deepseek/deepseek-chat",
            "anthropic/claude-3.7-sonnet",
            "anthropic/claude-sonnet-4",
            "qwen/qwen-2.5-coder-32b-instruct",
            "qwen/qwen3-30b-a3b",
            "qwen/qwen3-235b-a22b",
            "meta-llama/llama-4-maverick",
            "meta-llama/llama-4-scout",
          },
          params = {
            chat = { temperature = 0.2, top_p = 1 },
            command = { temperature = 0.2, top_p = 1 },
          },
        },
        cerebras = {
          disable = false,
          style = "openai",
          endpoint = "https://api.cerebras.ai/v1/chat/completions",
          api_key = os.getenv("CEREBRAS_API_KEY"),
          models = {
            "llama3.1-8b",
            "llama3.1-70b",
          },
          params = {
            chat = { temperature = 0.2, top_p = 1 },
            command = { temperature = 0.2, top_p = 1 },
          },
        },
        deepseek = {
          api_key = os.getenv("DEEPSEEK_API_KEY"),
        },
      },
      cmd_prefix = "Prt",
      chat_conceal_model_params = false,
      user_input_ui = "buffer",
      toggle_target = "tabnew",
      online_model_selection = true,
      command_auto_select_response = true,
      hooks = {
        Complete = function(prt, params)
          local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted."
        ]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
        CompleteFullContext = function(prt, params)
          local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{filecontent}}
        ```

        Please look at the following section specifically:
        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted.
        ]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
        CompleteMultiContext = function(prt, params)
          local template = [[
        I have the following code from {{filename}} and other realted files:

        ```{{filetype}}
        {{multifilecontent}}
        ```

        Please look at the following section specifically:
        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted.
        ]]
          local model_obj = prt.get_model("command")
          prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
        end,
        Explain = function(prt, params)
          local template = [[
        Your task is to take the code snippet from {{filename}} and explain it with gradually increasing complexity.
        Break down the code's functionality, purpose, and key components.
        The goal is to help the reader understand what the code does and how it works.

        ```{{filetype}}
        {{selection}}
        ```

        Use the markdown format with codeblocks and inline code.
        Explanation of the code above:
        ]]
          local model = prt.get_model("command")
          prt.logger.info("Explaining selection with model: " .. model.name)
          prt.Prompt(params, prt.ui.Target.new, model, nil, template)
        end,
        FixBugs = function(prt, params)
          local template = [[
        You are an expert in {{filetype}}.
        Fix bugs in the below code from {{filename}} carefully and logically:
        Your task is to analyze the provided {{filetype}} code snippet, identify
        any bugs or errors present, and provide a corrected version of the code
        that resolves these issues. Explain the problems you found in the
        original code and how your fixes address them. The corrected code should
        be functional, efficient, and adhere to best practices in
        {{filetype}} programming.

        ```{{filetype}}
        {{selection}}
        ```

        Fixed code:
        ]]
          local model_obj = prt.get_model("command")
          prt.logger.info("Fixing bugs in selection with model: " .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
        end,
        Optimize = function(prt, params)
          local template = [[
        You are an expert in {{filetype}}.
        Your task is to analyze the provided {{filetype}} code snippet and
        suggest improvements to optimize its performance. Identify areas
        where the code can be made more efficient, faster, or less
        resource-intensive. Provide specific suggestions for optimization,
        along with explanations of how these changes can enhance the code's
        performance. The optimized code should maintain the same functionality
        as the original code while demonstrating improved efficiency.

        ```{{filetype}}
        {{selection}}
        ```

        Optimized code:
        ]]
          local model_obj = prt.get_model("command")
          prt.logger.info("Optimizing selection with model: " .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.new, model_obj, nil, template)
        end,
        UnitTests = function(prt, params)
          local template = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{selection}}
        ```

        Please respond by writing table driven unit tests for the code above.
        ]]
          local model_obj = prt.get_model("command")
          prt.logger.info("Creating unit tests for selection with model: " .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
        end,
        Debug = function(prt, params)
          local template = [[
        I want you to act as {{filetype}} expert.
        Review the following code, carefully examine it, and report potential
        bugs and edge cases alongside solutions to resolve them.
        Keep your explanation short and to the point:

        ```{{filetype}}
        {{selection}}
        ```
        ]]
          local model_obj = prt.get_model("command")
          prt.logger.info("Debugging selection with model: " .. model_obj.name)
          prt.Prompt(params, prt.ui.Target.enew, model_obj, nil, template)
        end,
        CommitMsg = function(prt, params)
          local futils = require("parrot.file_utils")
          if futils.find_git_root() == "" then
            prt.logger.warning("Not in a git repository")
            return
          else
            local template = [[
          I want you to act as a commit message generator. I will provide you
          with information about the task and the prefix for the task code, and
          I would like you to generate an appropriate commit message using the
          conventional commit format. Do not write any explanations or other
          words, just reply with the commit message.
          Start with a short headline as summary but then list the individual
          changes in more detail.

          Here are the changes that should be considered by this message:
          ]] .. vim.fn.system("git diff --no-color --no-ext-diff --staged")
            local model_obj = prt.get_model("command")
            prt.Prompt(params, prt.ui.Target.append, model_obj, nil, template)
          end
        end,
        SpellCheck = function(prt, params)
          local chat_prompt = [[
        Your task is to take the text provided and rewrite it into a clear,
        grammatically correct version while preserving the original meaning
        as closely as possible. Correct any spelling mistakes, punctuation
        errors, verb tense issues, word choice problems, and other
        grammatical mistakes.
        ]]
          prt.ChatNew(params, chat_prompt)
        end,
        CodeConsultant = function(prt, params)
          local chat_prompt = [[
          Your task is to analyze the provided {{filetype}} code and suggest
          improvements to optimize its performance. Identify areas where the
          code can be made more efficient, faster, or less resource-intensive.
          Provide specific suggestions for optimization, along with explanations
          of how these changes can enhance the code's performance. The optimized
          code should maintain the same functionality as the original code while
          demonstrating improved efficiency.

          Here is the code
          ```{{filetype}}
          {{filecontent}}
          ```
        ]]
          prt.ChatNew(params, chat_prompt)
        end,
        ProofReader = function(prt, params)
          local chat_prompt = [[
        I want you to act as a proofreader. I will provide you with texts and
        I would like you to review them for any spelling, grammar, or
        punctuation errors. Once you have finished reviewing the text,
        provide me with any necessary corrections or suggestions to improve the
        text. Highlight the corrected fragments (if any) using markdown backticks.

        When you have done that subsequently provide me with a slightly better
        version of the text, but keep close to the original text.

        Finally provide me with an ideal version of the text.

        Whenever I provide you with text, you reply in this format directly:

        ## Corrected text:

        {corrected text, or say "NO_CORRECTIONS_NEEDED" instead if there are no corrections made}

        ## Slightly better text

        {slightly better text}

        ## Ideal text

        {ideal text}
        ]]
          prt.ChatNew(params, chat_prompt)
        end,
      },
    })
  end,
  keys = {
    { "<localleader>pc", "<cmd>PrtChatNew<cr>", mode = { "n", "i" }, desc = "New Chat" },
    { "<localleader>pc", ":<C-u>'<,'>PrtChatNew<cr>", mode = { "v" }, desc = "Visual Chat New" },
    { "<localleader>pg", "<cmd>PrtChatRespond<cr>", desc = "🦜 Respond to Parrot Chat" },
    { "<localleader>pt", "<cmd>PrtChatToggle<cr>", mode = { "n", "i" }, desc = "Toggle Popup Chat" },
    { "<localleader>pf", "<cmd>PrtChatFinder<cr>", mode = { "n", "i" }, desc = "Chat Finder" },
    { "<localleader>pr", "<cmd>PrtRewrite<cr>", mode = { "n", "i" }, desc = "Inline Rewrite" },
    { "<localleader>pr", ":<C-u>'<,'>PrtRewrite<cr>", mode = { "v" }, desc = "Visual Rewrite" },
    {
      "<localleader>pj",
      "<cmd>PrtRetry<cr>",
      mode = { "n" },
      desc = "Retry rewrite/append/prepend command",
    },
    { "<localleader>pa", "<cmd>PrtAppend<cr>", mode = { "n", "i" }, desc = "Append" },
    { "<localleader>pa", ":<C-u>'<,'>PrtAppend<cr>", mode = { "v" }, desc = "Visual Append" },
    { "<localleader>po", "<cmd>PrtPrepend<cr>", mode = { "n", "i" }, desc = "Prepend" },
    { "<localleader>po", ":<C-u>'<,'>PrtPrepend<cr>", mode = { "v" }, desc = "Visual Prepend" },
    { "<localleader>pe", ":<C-u>'<,'>PrtEnew<cr>", mode = { "v" }, desc = "Visual Enew" },
    { "<localleader>ps", "<cmd>PrtStop<cr>", mode = { "n", "i", "v", "x" }, desc = "Stop" },
    {
      "<localleader>pi",
      ":<C-u>'<,'>PrtComplete<cr>",
      mode = { "n", "i", "v", "x" },
      desc = "Complete visual selection",
    },
    { "<localleader>px", "<cmd>PrtContext<cr>", mode = { "n" }, desc = "Open context file" },
    { "<localleader>pn", "<cmd>PrtModel<cr>", mode = { "n" }, desc = "Select model" },
    { "<localleader>pp", "<cmd>PrtProvider<cr>", mode = { "n" }, desc = "Select provider" },
    { "<localleader>pq", "<cmd>PrtAsk<cr>", mode = { "n" }, desc = "Ask a question" },
  },
}
