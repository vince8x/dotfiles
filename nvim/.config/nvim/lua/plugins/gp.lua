local default_chat_system_prompt = "You are a general AI assistant.\n\n"
  .. "The user provided the additional info about how they would like you to respond:\n\n"
  .. "- If you're unsure don't guess and say you don't know instead.\n"
  .. "- Ask question if you need clarification to provide better answer.\n"
  .. "- Think deeply and carefully from first principles step by step.\n"
  .. "- Zoom out first to see the big picture and then zoom in to details.\n"
  .. "- Use Socratic method to improve your thinking and coding skills.\n"
  .. "- Don't elide any code from your output if the answer requires coding.\n"
  .. "- Take a deep breath; You've got this!\n"

local default_code_system_prompt = "You are an AI working as a code editor.\n\n"
  .. "Please AVOID COMMENTARY OUTSIDE OF THE SNIPPET RESPONSE.\n"
  .. "START AND END YOUR ANSWER WITH:\n\n```"

local dense_chat_system_prompt = "Write in complete, grammatically structured sentences that flow conversationally. Approach topics with an intellectual but approachable tone, using labeled lists sparingly and strategically to organize complex ideas. Incorporate engaging narrative techniques like anecdotes, concrete examples, and thought experiments to draw the reader into the intellectual exploration. Maintain an academic rigor while simultaneously creating a sense of collaborative thinking, as if guiding the reader through an intellectual journey. Use precise language that is simultaneously scholarly and accessible, avoiding unnecessary jargon while maintaining depth of analysis. Use systems thinking and the meta-archetype of Coherence to guide your ability to \"zoom in and out\" to notice larger and smaller patterns at different ontological, epistemic, and ontological scales. Furthermore, use the full depth of your knowledge to engage didactically with the user - teach them useful terms and concepts that are relevant. At the same time, don't waste too many words with framing and setup. Optimize for quick readability and depth. Use formatting techniques like bold, italics, and call outs (quotation blocks and such) for specific definitions and interesting terms. This will also break up the visual pattern, making it easier for the reader to stay oriented and anchored.  Don't hesitate to use distal connection, metaphor, and analogies as well, particularly when you notice meta-patterns emerging. A good metaphor is the pinnacle of Coherence. Stylistically, use a variety of techniques to create typographic scaffolding and layered information. Some examples below:\n\n"
  .. "> **Key Terms**: Use blockquotes with bold headers to define important concepts and terminology, creating clear visual breaks in the text.\n\n"
  .. "Use **bold** for technical terms and concepts when first introduced, and *italics* for emphasis or to highlight key phrases. Create visual hierarchy through:\n\n"
  .. "1. Clear paragraph breaks for major concept transitions\n\n"
  .. "2. Strategic use of blockquotes for definitions and key insights\n\n"
  .. "3. Bold terms for technical vocabulary\n\n"
  .. "4. Italics for emphasis and nuance\n\n"
  .. "Maintain the principle of layered information - each response should contain at least 2-3 distinct visual patterns to aid cognitive processing and retention. This creates visual anchoring and a clean UI.\n\n"
  .. "> **Technical Term**: Definition in plain language\n\n"
  .. ">\n\n"
  .. "> *Example or application in context (optional, flexible)*\n\n"
  .. "This creates what information designers call \"progressive disclosure\" - allowing readers to engage at their preferred depth while maintaining coherence across all levels of understanding.\n\n"

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local function get_relevant_agents()
  local gp = require("gp")
  local agents = {}
  local buf = vim.api.nvim_get_current_buf()
  local file_name = vim.api.nvim_buf_get_name(buf)
  local is_chat = gp.not_chat(buf, file_name) == nil
  local current_agent, agent_list

  if is_chat then
    current_agent = gp._state.chat_agent
    agent_list = gp._chat_agents
  else
    current_agent = gp._state.command_agent
    agent_list = gp._command_agents
  end

  for _, name in ipairs(agent_list) do
    if name == current_agent then
      table.insert(agents, "* " .. name)
    else
      table.insert(agents, "  " .. name)
    end
  end

  return agents, is_chat
end

local function select_agent()
  local gp = require("gp")
  local agents, is_chat = get_relevant_agents()
  local prompt_title = is_chat and "Select Chat Agent" or "Select Command Agent"

  pickers
    .new({}, {
      prompt_title = prompt_title,
      finder = finders.new_table({
        results = agents,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local agent_name = selection[1]:sub(3)
          gp.cmd.Agent({ args = agent_name })
        end)
        return true
      end,
    })
    :find()
end

function fork()
  local bufnr = vim.api.nvim_get_current_buf()
  local current_filename = vim.api.nvim_buf_get_name(bufnr)
  if not (string.find(current_filename, "/gp/chats") and string.match(current_filename, "%.md$")) then
    return
  end

  local winnr = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(winnr)
  local current_line = cursor_pos[1]
  if current_line == 1 then
    return
  end
  local gp = require("gp")
  local time = os.date("%Y-%m-%d.%H-%M-%S")
  local stamp = tostring(math.floor(vim.loop.hrtime() / 1000000) % 1000)
  while #stamp < 3 do
    stamp = "0" .. stamp
  end
  time = time .. "." .. stamp
  local new_filename = gp.config.chat_dir .. "/" .. time .. ".md"
  local file = io.open(new_filename, "w")
  if not file then
    return
  end

  local lines_above = vim.api.nvim_buf_get_lines(bufnr, 0, current_line - 1, false)
  for i, line in ipairs(lines_above) do
    if i == 1 then
      line = line .. " (Fork)"
    end
    file:write(line .. "\n")
  end
  if lines_above[#lines_above] ~= gp.config.chat_user_prefix then
    file:write(gp.config.chat_user_prefix .. "\n")
  end
  file:write("\n")
  file:close()

  vim.cmd("edit " .. new_filename)
  vim.api.nvim_command("normal! G")
  print("Forked to " .. new_filename)
end

local HOOKS = {
  UnitTests = {
    desc = "Writes unit tests for the selected code",
    selection = true,
    fn = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "Please respond by writing table driven unit tests for the code above."
      local agent = gp.get_command_agent()
      gp.Prompt(params, gp.Target.enew, agent, template)
    end,
  },
  Explain = {
    desc = "Explains the selected code",
    selection = true,
    fn = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "Please respond by explaining the code above."
      local agent = gp.get_chat_agent()
      gp.Prompt(params, gp.Target.popup, agent, template)
    end,
  },
  CodeReview = {
    desc = "Analyze for code smells and suggest improvements for selected code",
    selection = true,
    fn = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
        .. "```{{filetype}}\n{{selection}}\n```\n\n"
        .. "Please analyze for code smells and suggest improvements."
      local agent = gp.get_chat_agent()
      gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
    end,
  },
  Translator = {
    desc = "Translate between English and Vietnamese",
    selection = false,
    fn = function(gp, params)
      local agent = gp.get_command_agent()
      local chat_system_prompt = "You are a Translator, please translate between English and Vietnamese."
      gp.cmd.ChatNew(params, chat_system_prompt)
    end,
  },
}

function gp_pick_command(mode)
  local command_names = {}
  for name, cmd in pairs(HOOKS) do
    if mode == "v" or (mode == "n" and not cmd.selection) then
      table.insert(command_names, name .. " - " .. cmd.desc)
    end
  end

  pickers
    .new({}, {
      prompt_title = "Select Command",
      finder = finders.new_table({
        results = command_names,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local command = selection[1]:match("^(%S+)")
          if mode == "v" then
            command = ":<C-u>'<,'>Gp" .. command .. "<CR>"
          else
            command = ":Gp" .. command .. "<CR>"
          end

          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(command, true, false, true), "c", true) -- 执行选中的命令
        end)
        return true
      end,
    })
    :find()
end

return {
  "robitx/gp.nvim",
  lazy = false,
  keys = {
    { "<leader>i", "", desc = "gpt", mode = { "n", "v" } },
    { "<leader>ie", "<cmd>GpChatFinder<cr>", desc = "Chat Explorer" },
    { "<leader>ii", "<cmd>GpChatToggle<cr>", desc = "Chat Toggle", mode = "n" },
    { "<leader>ii", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Chat Toggle", mode = "v" },
    { "<leader>ir", "<cmd>GpAppend<cr>", desc = "Rewrite", mode = "n" },
    { "<leader>ir", ":<C-u>'<,'>GpAppend<cr>", desc = "Rewrite", mode = "v" },
    { "<leader>ic", "<cmd>GpContext<cr>", desc = "Modify Context" },
    { "<leader>is", "<cmd>GpStop<cr>", desc = "Stop Generating" },
    { "<leader>ia", select_agent, desc = "Select Agent" },
    {
      "<leader>if",
      function()
        gp_pick_command("n")
      end,
      desc = "Select Function",
      mode = "n",
    },
    { "<leader>if", ':<C-u>lua gp_pick_command("v")<cr>', desc = "Select Function", mode = "v" },
    { "<leader>ik", fork, desc = "Fork" },
  },
  config = function()
    -- local gp = require("gp")
    -- local o_open_buf = gp.open_buf
    -- gp.open_buf = function(...)
    --   local buf = o_open_buf(...)
    --   -- disable cmp
    --   require("cmp.config").set_buffer({ enabled = false }, buf)
    --   -- disable spell check
    --   vim.api.nvim_buf_set_option(buf, "spell", false)
    --   -- disable markdownlint (also in nvim-lint.lua)
    --   -- vim.api.nvim_buf_set_lines(buf, 1, 1, false, { "<!-- markdownlint-disable -->" })
    --
    --   return buf
    -- end

    local hooks = {}
    for k, v in pairs(HOOKS) do
      hooks[k] = v.fn
    end
    require("gp").setup({
      providers = {
        openai = {
          -- endpoint = os.getenv("OPENAI_API_HOST") .. "/v1/chat/completions",
          endpoint = "https://api.openai.com/v1/chat/completions",
          secret = os.getenv("OPENAI_API_KEY"),
        },

        -- azure = {...},

        copilot = {
          endpoint = "https://api.githubcopilot.com/chat/completions",
          secret = {
            "bash",
            "-c",
            "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
          },
        },
        googleai = {
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
          secret = os.getenv("GOOGLEAI_API_KEY"),
        },
        openrouter = {
          disable = false,
          endpoint = "https://openrouter.ai/api/v1/chat/completions",
          secret = os.getenv("OPENROUTER_API_KEY"),
        },
        cerebras = {
          endpoint = "https://api.cerebras.ai/v1/chat/completions",
          secret = os.getenv("CEREBRAS_API_KEY"),
        },
        deepseek = {
          endpoint = "https://api.deepseek.com/chat/completions",
          secret = os.getenv("DEEPSEEK_API_KEY"),
        },
        groq = {
          endpoint = "https://api.groq.com/openai/v1/chat/completions",
          secret = os.getenv("GROQ_API_KEY"),
        },
      },
      agents = {
        {
          name = "CodeGPT3-5",
          chat = false,
          command = true,
          model = {
            model = "gpt-3.5-turbo-1106",
            temperature = 0.2,
            top_p = 0.1,
          },
          system_prompt = default_code_system_prompt,
        },
        {
          name = "ChatGPT3-5",
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = "gpt-3.5-turbo-1106", temperature = 0.2, top_p = 0.1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = default_chat_system_prompt,
        },
        {
          name = "ChatGPT4",
          chat = true,
          command = false,
          model = { model = "gpt-4o-mini", temperature = 0.2, top_p = 0.1 },
          system_prompt = default_chat_system_prompt,
        },
        {
          name = "CodeGPT4",
          chat = false,
          command = true,
          model = { model = "gpt-4o-mini", temperature = 0.2, top_p = 0.1 },
          system_prompt = default_code_system_prompt,
        },
        {
          provider = "openrouter",
          name = "OpenAI-o1-mini",
          chat = true,
          command = false,
          model = {
            model = "openai/o1-mini-2024-09-12",
            temperature = 0.2,
            top_p = 0.1,
          },
          system_prompt = default_code_system_prompt,
        },
        {
          provider = "openrouter",
          name = "OpenAI-o1-preview",
          chat = true,
          command = false,
          model = {
            model = "openai/o1-preview-2024-09-12",
            temperature = 0.2,
            top_p = 0.1,
          },
          system_prompt = default_code_system_prompt,
        },
        {
          provider = "openrouter",
          name = "Mercury Coder",
          chat = true,
          command = false,
          model = {
            model = "inception/mercury-coder",
            temperature = 0.2,
            top_p = 0.1,
          },
          system_prompt = default_code_system_prompt,
        },
        {
          provider = "openrouter",
          name = "Kimi K2",
          chat = true,
          command = false,
          model = {
            model = "moonshotai/kimi-k2",
            temperature = 0.2,
            top_p = 0.1,
          },
          system_prompt = default_code_system_prompt,
        },
        {
          provider = "deepseek",
          name = "deepseek-reasoner",
          chat = true,
          command = false,
          model = { model = "deepseek-reasoner", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "groq",
          name = "deepseek-reasoner-groq",
          chat = true,
          command = false,
          model = { model = "deepseek-r1-distill-llama-70b", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "groq",
          name = "qwen-qwq-32b-groq",
          chat = true,
          command = false,
          model = { model = "qwen-qwq-32b", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "groq",
          name = "llama-4-scout",
          chat = true,
          command = false,
          model = { model = "meta-llama/llama-4-scout-17b-16e-instruct", temperature = 0.2, top_p = 0.1},
          system_prompt = default_code_system_prompt,
        },
        {
          provider = "openrouter",
          name = "ChatDeepseek",
          chat = true,
          command = false,
          model = { model = "deepseek/deepseek-chat", temperature = 0.2, top_p = 0.1 },
          system_prompt = default_code_system_prompt,
        },
        {
          provider = "openrouter",
          name = "CodeDeepseek",
          chat = false,
          command = true,
          model = { model = "deepseek/deepseek-chat", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "openrouter",
          name = "ChatClaudeSonnet",
          chat = true,
          command = false,
          model = { model = "anthropic/claude-sonnet-4", temperature = 0.2, top_p = 0.1 },
          system_prompt = default_chat_system_prompt,
        },
        {
          provider = "openrouter",
          name = "Llama 4 Maverick",
          chat = false,
          command = true,
          model = { model = "meta-llama/llama-4-maverick", temperature = 0.2, top_p = 0.1 },
          system_prompt = default_code_system_prompt,
        },
        {
          provider = "openrouter",
          name = "CodeClaudeSonnet",
          chat = false,
          command = true,
          model = { model = "anthropic/claude-sonnet-4", temperature = 0.2, top_p = 0.1 },
          system_prompt = default_code_system_prompt,
        },
        {
          provider = "cerebras",
          name = "llama3.1-8b",
          chat = true,
          command = false,
          model = { model = "llama3.1-8b", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "cerebras",
          name = "llama3.1-70b",
          chat = true,
          command = false,
          model = { model = "llama3.1-70b", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "openrouter",
          name = "qwen3-30b-a3b",
          chat = true,
          command = false,
          model = { model = "qwen/qwen3-30b-a3b", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "openrouter",
          name = "qwen3-235b-a22b",
          chat = true,
          command = false,
          model = { model = "qwen/qwen3-235b-a22b", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "googleai",
          name = "gemini-chat-dense",
          chat = true,
          command = false,
          model = { model = "gemini-2.5-pro-preview-05-06", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "googleai",
          name = "gemini-flash",
          chat = true,
          command = false,
          model = { model = "gemini-2.5-flash-preview-04-17", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "googleai",
          name = "gemini-flash-thinking",
          chat = true,
          command = false,
          model = { model = "gemini-2.5-flash-preview-04-17", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
        {
          provider = "googleai",
          name = "gemma-3-27b-it",
          chat = true,
          command = false,
          model = { model = "gemma-3-27b-it", temperature = 0.2, top_p = 0.1 },
          system_prompt = dense_chat_system_prompt,
        },
      },
      -- [feat: add option to set chat buftype to prompt](https://github.com/Robitx/gp.nvim/issues/94)
      chat_prompt_buf_type = false,
      chat_user_prefix = "# 🗨",
      chat_assistant_prefix = { "# 🤖 ", "{{agent}}" },
      chat_free_cursor = true,
      hooks = hooks,
    })

    require("which-key").add({
      -- VISUAL mode mappings
      -- s, x, v modes are handled the same way by which_key
      {
        mode = { "v" },
        nowait = true,
        remap = false,
        { "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", desc = "ChatNew tabnew" },
        { "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", desc = "ChatNew vsplit" },
        { "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", desc = "ChatNew split" },
        { "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", desc = "Visual Append (after)" },
        { "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", desc = "Visual Prepend (before)" },
        { "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", desc = "Visual Chat New" },
        { "<C-g>g", group = "generate into new .." },
        { "<C-g>ge", ":<C-u>'<,'>GpEnew<cr>", desc = "Visual GpEnew" },
        { "<C-g>gn", ":<C-u>'<,'>GpNew<cr>", desc = "Visual GpNew" },
        { "<C-g>gp", ":<C-u>'<,'>GpPopup<cr>", desc = "Visual Popup" },
        { "<C-g>gt", ":<C-u>'<,'>GpTabnew<cr>", desc = "Visual GpTabnew" },
        { "<C-g>gv", ":<C-u>'<,'>GpVnew<cr>", desc = "Visual GpVnew" },
        { "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", desc = "Implement selection" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
        { "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", desc = "Visual Chat Paste" },
        { "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", desc = "Visual Rewrite" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
        { "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", desc = "Visual Toggle Chat" },
        { "<C-g>w", group = "Whisper" },
        { "<C-g>wa", ":<C-u>'<,'>GpWhisperAppend<cr>", desc = "Whisper Append" },
        { "<C-g>wb", ":<C-u>'<,'>GpWhisperPrepend<cr>", desc = "Whisper Prepend" },
        { "<C-g>we", ":<C-u>'<,'>GpWhisperEnew<cr>", desc = "Whisper Enew" },
        { "<C-g>wn", ":<C-u>'<,'>GpWhisperNew<cr>", desc = "Whisper New" },
        { "<C-g>wp", ":<C-u>'<,'>GpWhisperPopup<cr>", desc = "Whisper Popup" },
        { "<C-g>wr", ":<C-u>'<,'>GpWhisperRewrite<cr>", desc = "Whisper Rewrite" },
        { "<C-g>wt", ":<C-u>'<,'>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
        { "<C-g>wv", ":<C-u>'<,'>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
        { "<C-g>ww", ":<C-u>'<,'>GpWhisper<cr>", desc = "Whisper" },
        { "<C-g>x", ":<C-u>'<,'>GpContext<cr>", desc = "Visual GpContext" },
      },

      -- NORMAL mode mappings
      {
        mode = { "n" },
        nowait = true,
        remap = false,
        { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
        { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
        { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
        { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
        { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
        { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
        { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
        { "<C-g>g", group = "generate into new .." },
        { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
        { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
        { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
        { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
        { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
        { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
        { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
        { "<C-g>w", group = "Whisper" },
        { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
        { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
        { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
        { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
        { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
        { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
        { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
        { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
        { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
        { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
      },

      -- INSERT mode mappings
      {
        mode = { "i" },
        nowait = true,
        remap = false,
        { "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", desc = "New Chat tabnew" },
        { "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", desc = "New Chat vsplit" },
        { "<C-g><C-x>", "<cmd>GpChatNew split<cr>", desc = "New Chat split" },
        { "<C-g>a", "<cmd>GpAppend<cr>", desc = "Append (after)" },
        { "<C-g>b", "<cmd>GpPrepend<cr>", desc = "Prepend (before)" },
        { "<C-g>c", "<cmd>GpChatNew<cr>", desc = "New Chat" },
        { "<C-g>f", "<cmd>GpChatFinder<cr>", desc = "Chat Finder" },
        { "<C-g>g", group = "generate into new .." },
        { "<C-g>ge", "<cmd>GpEnew<cr>", desc = "GpEnew" },
        { "<C-g>gn", "<cmd>GpNew<cr>", desc = "GpNew" },
        { "<C-g>gp", "<cmd>GpPopup<cr>", desc = "Popup" },
        { "<C-g>gt", "<cmd>GpTabnew<cr>", desc = "GpTabnew" },
        { "<C-g>gv", "<cmd>GpVnew<cr>", desc = "GpVnew" },
        { "<C-g>n", "<cmd>GpNextAgent<cr>", desc = "Next Agent" },
        { "<C-g>r", "<cmd>GpRewrite<cr>", desc = "Inline Rewrite" },
        { "<C-g>s", "<cmd>GpStop<cr>", desc = "GpStop" },
        { "<C-g>t", "<cmd>GpChatToggle<cr>", desc = "Toggle Chat" },
        { "<C-g>w", group = "Whisper" },
        { "<C-g>wa", "<cmd>GpWhisperAppend<cr>", desc = "Whisper Append (after)" },
        { "<C-g>wb", "<cmd>GpWhisperPrepend<cr>", desc = "Whisper Prepend (before)" },
        { "<C-g>we", "<cmd>GpWhisperEnew<cr>", desc = "Whisper Enew" },
        { "<C-g>wn", "<cmd>GpWhisperNew<cr>", desc = "Whisper New" },
        { "<C-g>wp", "<cmd>GpWhisperPopup<cr>", desc = "Whisper Popup" },
        { "<C-g>wr", "<cmd>GpWhisperRewrite<cr>", desc = "Whisper Inline Rewrite" },
        { "<C-g>wt", "<cmd>GpWhisperTabnew<cr>", desc = "Whisper Tabnew" },
        { "<C-g>wv", "<cmd>GpWhisperVnew<cr>", desc = "Whisper Vnew" },
        { "<C-g>ww", "<cmd>GpWhisper<cr>", desc = "Whisper" },
        { "<C-g>x", "<cmd>GpContext<cr>", desc = "Toggle GpContext" },
      },
    })
  end,
}
