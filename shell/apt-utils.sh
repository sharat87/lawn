#----------------------------------------
# aptitude utilities
#----------------------------------------

# Master aptitude command.
a () {
	local cmd=$1

	case "$cmd" in
		changelog|download|help|show|search|versions|why|why-not)
			aptitude "$@"
			;;
		*)
			sudo aptitude "$@"
			;;
	esac
}

compdef _aptitude a

# search command
alias a/='aptitude search'

# show command
aw () {
	if ! aptitude show "$@"; then
		local search_output="$(aptitude search "$@")"

		if [[ -z $search_output ]]; then
			echo 'No search results either.' >&2

		elif [[ "$(echo "$search_output" | wc -l)" == 1 ]]; then
			local package="$(echo "$search_output" | awk '{print $2}')"
			echo "You are probably looking for $package.\n"
			aw $package

		else
			{
				echo "There's no package called $1. Here's a search result:"
				echo "$search_output"
			} | $PAGER

		fi
	fi
}

# install command
ai () {
	if sudo aptitude install "$@"; then
		transient-notify "aptitude" "$1 installation finished"
	else
		transient-notify "aptitude" "Error installing $1"
	fi
}

compdef "_a install" ai

# purge command
ap () {
	if sudo aptitude purge "$@"; then
		transient-notify "aptitude" "$1 purged"
	else
		transient-notify "aptitude" "Error purging $1"
	fi
}

compdef "_a purge" ap

# remove command (ar is the archive command)
ad () {
	if sudo aptitude remove "$@"; then
		transient-notify "aptitude" "$1 removed"
	else
		transient-notify "aptitude" "Error removing $1"
	fi
}

compdef "_a remove" ad

# update command
au () {
	sudo aptitude update "$@"
	transient-notify "aptitude" "Update finished"
}

compdef "_a update" au

_a () {
	words=( aptitude $1 $words[2,-1] )
	(( CURRENT++ ))
	shift
	_aptitude "$@"
}

# aptitude history
# Taken from https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/debian/debian.plugin.zsh
ah () {
	case "$1" in
		installs)
			zgrep --no-filename 'install ' $(ls -rt /var/log/dpkg*)
			;;
		upgrades|removes)
			zgrep --no-filename $1 $(ls -rt /var/log/dpkg*)
			;;
		rollbacks)
			zgrep --no-filename upgrade $(ls -rt /var/log/dpkg*) | \
				grep "$2" -A10000000 | \
				grep "$3" -B10000000 | \
				awk '{print $4"="$5}'
			;;
		all)
			zcat $(ls -rt /var/log/dpkg*)
			;;
		*)
			echo "Usage:"
			echo " installs - Lists all packages that have been installed."
			echo " upgrades - Lists all packages that have been upgraded."
			echo " removes - Lists all packages that have been removed."
			echo " rollbacks - Lists rollback information."
			echo " all - Lists all contains of dpkg logs."
			;;
	esac
}

_ah () {
	# compadd $(ah | awk '/^ / {print $1}')
	local ret=1 state
	_arguments ':subcommand:->subcommand' && ret=0

	case $state in
	  subcommand)
		subcommands=(
		  "installs:Lists all packages that have been installed."
		  "upgrades:Lists all packages that have been upgraded."
		  "removes:Lists all packages that have been removed."
		  "rollbacks:Lists rollback information."
		  "all:Lists all contains of dpkg logs."
		)
		_describe -t subcommands 'ah subcommands' subcommands && ret=0
	esac

	return ret
}

compdef _ah ah
