.PHONY: put links tools update powerline compilations
SHELL = /bin/bash

# Each line consists of a `source` url and a `destination`, which is relative to
# the home directory.
define TOOLS
https://bitbucket.org/sharat87/dtime/raw/tip/dtime bin/dtime
http://betterthangrep.com/ack-standalone bin/ack
https://raw.github.com/technomancy/leiningen/preview/bin/lein bin/lein2
https://raw.github.com/technomancy/leiningen/stable/bin/lein bin/lein
https://raw.github.com/flatland/cake/develop/bin/cake bin/cake
https://raw.github.com/holman/spark/master/spark bin/spark
https://bitbucket.org/sjl/t/raw/tip/t.py .t.py
https://raw.github.com/samirahmed/fu/master/src/fu.py bin/fu
https://raw.github.com/fireteam/curlish/master/curlish.py bin/curlish
https://raw.github.com/rkitover/vimpager/master/vimpager bin/vimp
endef
export TOOLS

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
nautilus-scripts .gnome2/nautilus-scripts
web/js
web/css
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
	$(MAKE) tools compilations

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

tools:
	@echo Downloading TOOLS.
	@echo "$$TOOLS" | while read line; do \
		url="$${line% *}"; \
		dst="$(HOME)/$${line#* }"; \
		wget --no-check-certificate -O "$$dst" "$$url" \
			&& chmod +x "$$dst"; \
	done

update:
	@# git submodule foreach git pull
	cd vim/vundle && git pull
	vim +BundleInstall! +qall
	$(MAKE) tools powerline compilations

powerline:
	pip install --upgrade --user git+git://github.com/Lokaltog/powerline
	wget --no-check-certificate -O ~/.fonts/PowerlineSymbols.otf \
		https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
	fc-cache -vf ~/.fonts
	mkdir -p ~/.fonts.conf
	wget --no-check-certificate -O ~/.fonts.conf/10-powerline-symbols.conf \
		https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf

compilations:
	@test -e vim/plugins/command-t && { \
		echo Compiling command-t; \
		cd vim/plugins/command-t/ruby/command-t; \
		ruby extconf.rb && $(MAKE); \
	}
