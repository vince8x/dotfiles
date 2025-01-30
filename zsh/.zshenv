export ANDROID_HOME=$HOME/Android/Sdk 
export XDG_CONFIG_HOME="$HOME/.config"
export PATH=$PATH:$ANDROID_HOME/tools 
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=/$HOME/.fzf-nova:$PATH
export PATH="$PATH:/opt/nvim-linux64/bin"

export PATH="$HOME/.tmuxifier/bin:$PATH"


export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH=/usr/local/go/bin:$PATH
export PATH=${PATH}:`go env GOPATH`/bin

export GITHUB_API_KEY=`pass show apikey/github`
export GITHUB_TOKEN=$GITHUB_API_KEY
# export OPENAI_API_KEY=`pass show apikey/openai`
export GROQ_API_KEY=`pass show apikey/groq`
export OPENAI_EMAIL=`pass show web/email`
export OPENAI_PASSWORD=`pass show web/password002`
export DEEPSEEK_API_KEY=`pass show apikey/deepseek`
export GEMINI_API_KEY=`pass show apikey/gemini`
export GOOGLEAI_API_KEY=$GEMINI_API_KEY
export OPENROUTER_API_KEY=`pass show apikey/openrouter`
export CEREBRAS_API_KEY=`pass show apikey/cerebras`


export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/share/pkgconfig
export CONFIG_DIR=$HOME/.config

export DENO_INSTALL="/home/vince8x/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export SRC_ENDPOINT=https://sourcegraph.com
export SRC_ACCESS_TOKEN=`pass show tokens/sourcegraph`

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH

source $HOME/.cargo/env
