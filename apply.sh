#!/bin/bash

set -o errexit
set -o nounset

lawn="$(cd "$(dirname $0)"; pwd)"

link() {
	local lawn_path="$lawn/$1"
	local home_path="$HOME/$2"
	if [[ ! -e "$home_path" ]]; then
		mkdir -p "$(dirname "$home_path")"
		ln -vsf "$lawn_path" "$home_path"
	else
		# TODO: Check if $home_path is a link, if not, show error. If yes, check if it points to $lawn_path.
		if [[ $(readlink "$home_path") == $lawn_path ]]; then
			echo "No change for '$lawn_path'."
		else
			echo "Something wrong with '$lawn_path -> $home_path'. Not doing this."
		fi
	fi
}

link "shell/zsh" .zshrc

link "vim/vimfiles" .vim
link "tmux.conf" .tmux.conf

link "alacritty.yml" .config/alacritty.yml

link "mongorc.js" .mongorc.js

link "qutebrowser" .qutebrowser
