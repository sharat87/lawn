SHELL = /bin/bash

# Each line consists of a source path, relative to `pwd` and an optional second
# argument, `destination`. If `destination` is not given it defaults to
# "$HOME/.{`basename` of source}". A link is created at `destination`, pointing
# to `source`.
define LINKS
git/config .gitconfig
git/ignore .gitignore
hg/hgrc
nemo-scripts .gnome2/nemo-scripts
nemo-scripts .local/share/nautilus/scripts
shell/bash .bashrc
shell/env .zshenv
shell/zsh .zshrc
tmux.conf
vim
vim/vimrc
endef
export LINKS

all:
	@test -d ~/.vim || ln -sv $$PWD/vim/vimfiles ~/.vim
	@test -f ~/.tmux.conf || ln -sv $$PWD/tmux.conf ~/.tmux.conf

put:
	rm -rf _originals
	mkdir -p _originals tmp/{undo,baks}
	${MAKE} links
	vim +PlugInstall +qall

links:
	@echo Setting up LINKS.
	@echo "$$LINKS" \
		| sed -n 's,^\([^[:space:]]\+/\)\?\([^[:space:]]\+\),& .\2,p' \
		| while read line; do \
			source="$$(readlink -f $${line%% *})"; \
			target="$$HOME/$${line##* }"; \
			test -e "$$target" && mv "$$target" _originals; \
			ln -s "$$source" "$$target"; \
		done

.PHONY: put links
