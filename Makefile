
.PHONY: put up tools compilations
SHELL := /bin/bash

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
http://defunkt.io/hub/standalone bin/hub
https://raw.github.com/rkitover/vimpager/master/vimpager bin/vim
endef
export TOOLS

showrun = echo $1; $1

# `call` with one or two arguments, first is the `source` and second is
# `destination`. If `destination` is not given it defaults to "$HOME/.<source>".
# A link is created at `destination`, pointing to `source`.
dln = _dst="$(HOME)/$(if $2,$2,.$(notdir $1))"; \
	test -e "$$_dst" && mv "$$_dst" _originals; \
	$(call showrun,ln -s "$(realpath $1)" "$$_dst")

put:

	@test -d '_originals' && { \
		echo '_originals already exists. Deleting it.'; \
		rm -Rf _originals; \
	}

	mkdir _originals

	git submodule init
	git submodule update

	@$(call dln,tmux.conf)

	@$(call dln,mail/offlineimap.conf,.offlineimaprc)

	@$(call dln,mutt/muttrc)

	@$(call dln,fabricrc)
	@$(call dln,toprc)

	@$(call dln,pentadactylrc)

	@$(call dln,nautilus-scripts,.gnome2/nautilus-scripts)

	@$(call dln,web/js)
	@$(call dln,web/css)

	@$(call dln,vim)
	@$(call dln,vim/vimrc)

	@$(call dln,git/config,.gitconfig)
	@$(call dln,git/ignore,.gitignore)

	@$(call dln,hg/hgrc)

	@$(call dln,shell/zsh,.zshrc)
	@$(call dln,shell/env,.zshenv)

	@$(call dln,shell/bash,.bashrc)

	mkdir -p tmp/undo

	@echo "$$TOOLS" | while read line; do \
		url="$${line% *}"; \
		dst="$(HOME)/$${line#* }"; \
		cmd="wget --no-check-certificate -O $$dst $$url"; \
		echo $$cmd; \
		$$cmd && chmod +x $$dst; \
	done

	$(MAKE) compilations

up:
	git submodule foreach git pull
	vim +BundleInstall! +qall
	$(MAKE) tools
	$(MAKE) compilations

compilations:
	@test -e vim/plugins/command-t && { \
		echo 'Compiling command-t'; \
		cd vim/plugins/command-t/ruby/command-t; \
		ruby extconf.rb && make; \
	}
