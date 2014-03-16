.PHONY: put links update
SHELL = /bin/bash

# Each line consists of a source path, relative to `pwd` and an optional second
# argument, `destination`. If `destination` is not given it defaults to
# "$HOME/.<`basename` of source>". A link is created at `destination`, pointing
# to `source`.
define LINKS
tmux.conf
mail/offlineimap.conf .offlineimaprc
mutt/muttrc
fabricrc
toprc
pentadactylrc
nemo-scripts .gnome2/nemo-scripts
vim
vim/vimrc
git/config .gitconfig
git/ignore .gitignore
hg/hgrc
shell/zsh .zshrc
shell/env .zshenv
shell/bash .bashrc
endef
export LINKS

put:
	rm -rf _originals/*
	mkdir -p tmp/undo
	git submodule init && git submodule update
	$(MAKE) links
	vim +BundleInstall +qall

links:
	@echo Setting up LINKS.
	@echo "$$LINKS" \
		| sed -n 's,^\([^[:space:]]\+/\)\?\([^[:space:]]\+\),& .\2,p' \
		| while read line; do \
			source="$$(readlink -f $${line%% *})"; \
			target="$(HOME)/$${line##* }"; \
			test -e "$$target" && mv "$$target" _originals; \
			ln -s "$$source" "$$target"; \
		done

update:
	git submodule foreach git pull
	vim +NeoBundleInstall! +qall
