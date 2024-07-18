export ANDROID_HOME=$HOME/Android/Sdk 
export PATH=$PATH:$ANDROID_HOME/tools 
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=/$HOME/.fzf-nova:$PATH


export PATH="$HOME/.tmuxifier/bin:$PATH"


export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH=/usr/local/go/bin:$PATH
export PATH=${PATH}:`go env GOPATH`/bin

export OPENAI_API_KEY=`pass show apikey/openai`
export GROQ_API_KEY=`pass show apikey/groq`
export OPENAI_EMAIL=`pass show web/email`
export OPENAI_PASSWORD=`pass show web/password002`
export DEEPSEEK_API_KEY=`pass show apikey/deepseek`
export GEMINI_API_KEY=`pass show apikey/gemini`
export OPENROUTER_API_KEY=`pass show apikey/openrouter`


. "$HOME/.cargo/env"
