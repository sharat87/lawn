#!/bin/bash

set -o errexit
set -o nounset

lawn="$(cd "$(dirname "$0")"; pwd)"

link() {
	local lawn_path="$lawn/$1"
	local home_path="$2"

	if [[ $home_path != /* ]]; then
		home_path="$HOME/$home_path"
	fi

	if [[ ! -e "$lawn_path" ]]; then
		echo "Nothing present at $lawn_path, skipping."
		return
	fi

	if [[ ! -e "$home_path" ]]; then
		mkdir -p "$(dirname "$home_path")"
		echo "$(tput setaf 2)$(tput bold)$(ln -vsf "$lawn_path" "$home_path")$(tput sgr 0)" | sed "s:$HOME:~:g"

	elif [[ $(readlink "$home_path") == "$lawn_path" ]]; then
		echo "$(tput setaf 4)No change for $lawn_path$(tput sgr 0)" | sed "s:$HOME:~:g"

	else
		echo "$(tput setaf 1)$(tput bold)Skipping '$lawn_path -> $home_path'$(tput sgr 0)" | sed "s:$HOME:~:g"

	fi
}

link "shell/zsh" .zshrc

link "vim/vimfiles" .vim
link "tmux.conf" .tmux.conf

link "git/config" .gitconfig

link "alacritty.yml" .config/alacritty.yml

link "mongorc.js" .mongorc.js
link "mongoshrc.js" .mongoshrc.js

link "qutebrowser" .qutebrowser

link "xbar" Library/"Application Support"/xbar/plugins

link "Caddyfile" /usr/local/etc/Caddyfile
