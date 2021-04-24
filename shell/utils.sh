# Enable color support
if [[ -x /usr/bin/dircolors ]]; then
	if [[ -r ~/.dircolors ]]; then
		eval "$(dircolors -b ~/.dircolors)"
	else
		eval "$(dircolors -b)"
	fi
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

is_linux="$([[ $(uname) == Linux ]] && echo true || echo false)"
is_macos="$([[ $(uname) == Darwin ]] && echo true || echo false)"

if $is_linux; then
	alias ll='ls -l --almost-all --classify --human-readable'
	alias la='ls --almost-all'
	alias l='ls --classify'
elif $is_macos; then
	alias l='ls -FG'
	alias la='ls -AG'
	alias ll='ls -lhG'
	alias lal='ls -lAhG'
fi

# Pager aliases
alias le=less

alias g=git
alias s=ssh

alias serve="python3 -m http.server"

alias m=gmake
compdef m=make

alias re='grep --perl-regex'

# `so` means `source` in vim :)
alias so='source'

if $is_linux; then
	alias pbcopy='xsel --clipboard --input'
	alias pbpaste='xsel --clipboard --output'
fi

# A nicer tree
alias tree='tree -C --charset utf-8'

# Command to quickly edit the utils file
alias eal='vim ~/lawn/shell/utils.sh && source ~/lawn/shell/utils.sh'

alias f='find'

alias va=vagrant
alias tf=terraform

alias md='mkdir -p'
mcd() {
	mkdir -p "$@" && cd "$1"
}

# Python stuff
alias py='python'
alias pipr='pip install -r requirements.txt'

# Directory traversal (these are added by oh-my-zsh)
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias d='dirs -v | head -10'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

###
# Utility functions/commands
###

if $is_linux; then
	o () {
		xdg-open "$@" &
	}
else
	alias o=open
fi

alias epoch-show='date +%s'
epoch-read () {
	date --date @$1
}

# Check if the given files (as arguments) are the same files, using md5 hashing.
same-files () {
	local quite=false

	if [[ $1 == -q ]]; then
		quite=true
		shift
	fi

	if [[ "$(md5sum "$@" | cut -d' ' -f1 | uniq | wc -l)" == 1 ]]; then
		$quite || echo Yes. They are the same, according to md5 hashing.
	else
		$quite || echo No. They are NOT the same, according to md5 hashing.
		return 1
	fi
}

json () {
	python -m json.tool $1 | pygmentize -l javascript
}

#----------------------------------------
# Miscellaneous
#----------------------------------------

# cd to an ancestral directory
cu () {

	if [[ -z $1 ]]; then
		echo Please give a dirname
		return 1
	fi

	local d="$(dirname "$(pwd)")"

	while [[ "$(basename "$d")" != $1 ]] && [[ $d != "/" ]]; do
		d="$(dirname "$d")"
	done

	if [[ $d == "/" ]]; then
		echo \"$1\" is not present in current path
	else
		cd "$d"
	fi

}

_cu () {
	compadd $(dirname "$PWD" | tr / \\n)
}

compdef _cu cu

# Copy the full absolute path into the clipboard, and also echo it. Handles the
# path in the argument, if any, else `pwd`.
copy-path () {
	local apath=
	if [[ -d "$1" ]]; then
		apath=$(cd "$1" && pwd)
	elif [[ -f "$1" ]]; then
		apath="$PWD/$1"
	fi
	echo -n $apath | pbcopy
	echo "Copied '$apath' to clipboard."
}

# Compress PDF files
compress-pdf () {
	local infile="$1"
	local outfile="$2"
	if [[ -z $outfile ]]; then
		outfile="${infile%\.pdf}.out.pdf"
	fi
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress \
		-dNOPAUSE -dQUIET -dBATCH -sOutputFile="$outfile" "$infile"
}
