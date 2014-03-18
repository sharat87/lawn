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
shell/bash .bashrc
shell/env .zshenv
shell/zsh .zshrc
tmux.conf
vim
vim/vimrc
endef
export LINKS

put:
	rm -rf _originals/*
	mkdir -p tmp/{undo,baks}
	${MAKE} links
	vim +NeoBundleInstall +qall

links:
	@echo Setting up LINKS.
	@echo "$$LINKS" \
		| sed -n 's,^\([^[:space:]]\+/\)\?\([^[:space:]]\+\),& .\2,p' \
		| while read line; do \
			source="$$(readlink -f $${line%% *})"; \
			target="${HOME}/$${line##* }"; \
			test -e "$$target" && mv "$$target" _originals; \
			ln -s "$$source" "$$target"; \
		done

.PHONY: put links
