#!/bin/sh
dmenu_prompts=~/.config/prompts/$(ls ~/.config/prompts/ | dmenu -i -p "Choose prompt file")
echo $dmenu_prompts
[ "$dmenu_notes" = "$HOME/.config/prompts/" ] && exit
while [ -d $dmenu_prompts ] 
do 
 dmenu_prompts=$dmenu_prompts/$(ls $dmenu_prompts | dmenu -i -p "Choose prompt file")
done

[ "$(echo "${dmenu_prompts##*.}")" = "txt" ] && cat ~/.config/prompts/"$dmenu_prompts" | xclip -selection clipboard
 && exit
st -e nvim $dmenu_prompts
