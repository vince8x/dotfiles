#!/bin/sh

# Define an array of text file extensions to copy to clipboard
TEXT_EXTENSIONS="txt md mdc"

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dmenu_dir="$1"

# Initial directory selection
choice=$(ls -1 "$dmenu_dir" | dmenu -i -p "Choose prompt file")
[ -z "$choice" ] && exit

# Set initial path
dmenu_prompts="$dmenu_dir/$choice"
[ ! -e "$dmenu_prompts" ] && exit

# Navigate directories recursively
while [ -d "$dmenu_prompts" ]; do
    choice=$(ls -1 "$dmenu_prompts" | dmenu -i -p "Choose prompt file")
    [ -z "$choice" ] && exit
    dmenu_prompts="$dmenu_prompts/$choice"
    [ ! -e "$dmenu_prompts" ] && exit
done

# Get file extension
file_ext="${dmenu_prompts##*.}"

# Handle text files - copy to clipboard
for ext in $TEXT_EXTENSIONS; do
    if [ "$file_ext" = "$ext" ]; then
        # Copy file path to PRIMARY selection (middle-click paste)
        echo "$dmenu_prompts" | xclip -selection primary
        
        # Copy file content to CLIPBOARD selection (Ctrl+V paste)
        cat "$dmenu_prompts" | xclip -selection clipboard -i
        
        exit
    fi
done

# Open other files in neovim
st -e nvim "$dmenu_prompts"
