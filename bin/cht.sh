#!/usr/bin/env bash
languages=$(echo "golang lua cpp c typescript nodejs csharp rust dotnet" | tr ' ' '\n')
core_utils=$(echo "xargs find mv sed awe tmux" | tr ' ' '\n')

selected=$(printf "$languages\n$core_utils" | fzf --prompt="󰧷 Cheatsheet  " --layout=reverse --border --exit-0)
read -p "query: " query

if printf $languages | grep -qs $selected; then
	query=$(echo $query | tr ' ' '+')
	# tmux neww bash -c "curl cht.sh/$selected/$query & while [:]; do sleep 1; done"
	tmux neww bash -c "curl cht.sh/$selected/$query & while [:]; do sleep 1; done"
else
	tmux neww bash -c "curl -s cht.sh/$selected/~$query | less"
fi
