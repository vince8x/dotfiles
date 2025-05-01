#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dmenu_dir="$1"

dmenu_prompts="$dmenu_dir/$(ls "$dmenu_dir" | dmenu -i -p "Choose prompt file")"
echo "$dmenu_prompts"
[ "$dmenu_prompts" = "$dmenu_dir" ] && exit

while [ -d "$dmenu_prompts" ]; do
    dmenu_prompts="$dmenu_prompts/$(ls "$dmenu_prompts" | dmenu -i -p "Choose prompt file")"
done

if [ "${dmenu_prompts##*.}" = "txt" ] || [ "${dmenu_prompts##*.}" = "md" ]; then
    echo "$dmenu_prompts" | xclip -selection clipboard
    cat "$dmenu_prompts" | xclip -selection clipboard -i && exit
fi

st -e nvim "$dmenu_prompts"
