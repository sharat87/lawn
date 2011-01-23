#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2011 zsh-syntax-highlighting contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this list of conditions
#    and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice, this list of
#    conditions and the following disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of the zsh-syntax-highlighting contributors nor the names of its contributors
#    may be used to endorse or promote products derived from this software without specific prior
#    written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------


# Token types styles.
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES=(
  default                       'none'
  isearch                       'fg=magenta,standout'
  special                       'fg=magenta,standout'
  unknown-token                 'fg=red,bold'
  reserved-word                 'fg=yellow'
  alias                         'fg=green'
  builtin                       'fg=green'
  function                      'fg=green'
  command                       'fg=green'
  hashed-command                'fg=green'
  path                          'underline'
  globbing                      'fg=blue'
  history-expansion             'fg=blue'
  single-hyphen-option          'none'
  double-hyphen-option          'none'
  back-quoted-argument          'none'
  single-quoted-argument        'fg=yellow'
  double-quoted-argument        'fg=yellow'
  dollar-double-quoted-argument 'fg=cyan'
  back-double-quoted-argument   'fg=cyan'
  bracket-error                 'fg=red,bold'
)

# Colors for bracket levels.
# Put as many color as you wish.
# Leave it as an empty array to disable.
ZSH_HIGHLIGHT_MATCHING_BRACKETS_STYLES=(
  'fg=blue,bold'
  'fg=green,bold'
  'fg=magenta,bold'
  'fg=yellow,bold'
  'fg=cyan,bold'
)

# Tokens that are always immediately followed by a command.
ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS=(
  '|' '||' ';' '&' '&&' 'noglob' 'nocorrect' 'builtin'
)

# ZLE highlight types.
zle_highlight=(
  special:$ZSH_HIGHLIGHT_STYLES[special]
  isearch:$ZSH_HIGHLIGHT_STYLES[isearch]
)

# Check if the argument is a path.
_zsh_check-path() {
  [[ -z ${(Q)arg} ]] && return 1
  [[ -e ${(Q)arg} ]] && return 0
  [[ ! -e ${(Q)arg:h} ]] && return 1
  [[ ${#BUFFER} == $end_pos && -n $(print ${(Q)arg}*(N)) ]] && return 0
  return 1
}

# Highlight special chars inside double-quoted strings
_zsh_highlight-string() {
  setopt localoptions noksharrays
  local i j k style
  # Starting quote is at 1, so start parsing at offset 2 in the string.
  for (( i = 2 ; i < end_pos - start_pos ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      '$')  style=$ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument];;
      "\\") style=$ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]
            (( k += 1 )) # Color following char too.
            (( i += 1 )) # Skip parsing the escaped char.
            ;;
      *)    continue;;
    esac
    region_highlight+=("$j $k $style")
  done
}

# Recolorize the current ZLE buffer.
_zsh_highlight-zle-buffer() {
  # Avoid doing the same work over and over
  [[ ${ZSH_PRIOR_HIGHLIGHTED_BUFFER:-} == $BUFFER ]] && [[ ${#region_highlight} -gt 0 ]] && (( ZSH_PRIOR_CURSOR == CURSOR )) && return
  ZSH_PRIOR_HIGHLIGHTED_BUFFER=$BUFFER
  ZSH_PRIOR_CURSOR=$CURSOR

  setopt localoptions extendedglob bareglobqual
  local new_expression=true
  local start_pos=0
  local highlight_glob=true
  local end_pos arg style
  region_highlight=()
  for arg in ${(z)BUFFER}; do
    local substr_color=0
    [[ $start_pos -eq 0 && $arg = 'noglob' ]] && highlight_glob=false
    ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]##[[:space:]]#}}))
    ((end_pos=$start_pos+${#arg}))
    if $new_expression; then
      new_expression=false
      res=$(LC_ALL=C builtin type -w $arg 2>/dev/null)
      case $res in
        *': reserved')  style=$ZSH_HIGHLIGHT_STYLES[reserved-word];;
        *': alias')     style=$ZSH_HIGHLIGHT_STYLES[alias]
                        local aliased_command="${"$(alias $arg)"#*=}"
                        if [[ ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)$aliased_command]:-}:+yes} = 'yes' && ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)$arg]:-}:+yes} != 'yes' ]]; then
                          ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS+=($arg)
                        fi
                        ;;
        *': builtin')   style=$ZSH_HIGHLIGHT_STYLES[builtin];;
        *': function')  style=$ZSH_HIGHLIGHT_STYLES[function];;
        *': command')   style=$ZSH_HIGHLIGHT_STYLES[command];;
        *': hashed')    style=$ZSH_HIGHLIGHT_STYLES[hashed-command];;
        *)              if _zsh_check-path; then
                          style=$ZSH_HIGHLIGHT_STYLES[path]
                        elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                          style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                        else
                          style=$ZSH_HIGHLIGHT_STYLES[unknown-token]
                        fi
                        ;;
      esac
    else
      case $arg in
        '--'*)   style=$ZSH_HIGHLIGHT_STYLES[double-hyphen-option];;
        '-'*)    style=$ZSH_HIGHLIGHT_STYLES[single-hyphen-option];;
        "'"*"'") style=$ZSH_HIGHLIGHT_STYLES[single-quoted-argument];;
        '"'*'"') style=$ZSH_HIGHLIGHT_STYLES[double-quoted-argument]
                 region_highlight+=("$start_pos $end_pos $style")
                 _zsh_highlight-string
                 substr_color=1
                 ;;
        '`'*'`') style=$ZSH_HIGHLIGHT_STYLES[back-quoted-argument];;
        *"*"*)   $highlight_glob && style=$ZSH_HIGHLIGHT_STYLES[globbing] || style=$ZSH_HIGHLIGHT_STYLES[default];;
        *)       if _zsh_check-path; then
                   style=$ZSH_HIGHLIGHT_STYLES[path]
                 elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                   style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                 else
                   style=$ZSH_HIGHLIGHT_STYLES[default]
                 fi
                 ;;
      esac
    fi
    [[ $substr_color = 0 ]] && region_highlight+=("$start_pos $end_pos $style")
    [[ ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]:-}:+yes} = 'yes' ]] && new_expression=true
    start_pos=$end_pos
  done

  # Bracket matching
  bracket_color_size=${#ZSH_HIGHLIGHT_MATCHING_BRACKETS_STYLES}
  if ((bracket_color_size > 0)); then
    typeset -A levelpos lastoflevel matching revmatching
    ((level = 0))
    for pos in {1..${#BUFFER}}; do
      case $BUFFER[pos] in
        "("|"["|"{")
          levelpos[$pos]=$((++level))
          lastoflevel[$level]=$pos
          ;;
        ")"|"]"|"}")
          matching[$lastoflevel[$level]]=$pos
          revmatching[$pos]=$lastoflevel[$level]
          levelpos[$pos]=$((level--))
          ;;
      esac
    done
    for pos in ${(k)levelpos}; do
      level=$levelpos[$pos]
      if ((level < 1)); then
        region_highlight+=("$((pos - 1)) $pos "$ZSH_HIGHLIGHT_STYLES[bracket-error])
      else
        region_highlight+=("$((pos - 1)) $pos "$ZSH_HIGHLIGHT_MATCHING_BRACKETS_STYLES[(( (level - 1) % bracket_color_size + 1 ))])
      fi
    done
    ((c = CURSOR + 1))
    if [[ -n $levelpos[$c] ]]; then
      ((otherpos = -1))
      [[ -n $matching[$c] ]] && otherpos=$matching[$c]
      [[ -n $revmatching[$c] ]] && otherpos=$revmatching[$c]
      region_highlight+=("$((otherpos - 1)) $otherpos standout")
    fi
  fi
}

# Special treatment for completion/expansion events:
# For each *complete* function (except 'accept-and-menu-complete'), 
# we create a widget which mimics the original
# and use this orig-* version inside the new colorized zle function (the dot
# idiom used for all others doesn't work right for these functions for some
# reason).  You can see the default setup using "zle -l -L".

# Bind all ZLE events from zle -la to highlighting function.
_zsh_highlight-install() {
  zmodload zsh/zleparameter 2>/dev/null || {
    echo 'zsh-syntax-highlighting:zmoadload error. exiting.' >&2; return -1
  }
  local -a events; : ${(A)events::=${@:#(_*|orig-*|.run-help|.which-command)}}
  local clean_event
  for event in $events; do
    if [[ "$widgets[$event]" == completion:* ]]; then
      eval "zle -C orig-$event ${${${widgets[$event]}#*:}/:/ } ; $event() { builtin zle orig-$event && _zsh_highlight-zle-buffer } ; zle -N $event"
    else
      case $event in
        accept-and-menu-complete)
          eval "$event() { builtin zle .$event && _zsh_highlight-zle-buffer } ; zle -N $event"
          ;;
        .*)
          clean_event=$event[2,${#event}] # Remove the leading dot in the event name
          case ${widgets[$clean_event]-} in
            (completion|user):*)
              ;;
            *)
              eval "$clean_event() { builtin zle $event && _zsh_highlight-zle-buffer } ; zle -N $clean_event"
              ;;
          esac
          ;;
        *)
          ;;
      esac
    fi
  done
}
_zsh_highlight-install "${(@f)"$(zle -la)"}"
