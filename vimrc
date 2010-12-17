" Author: Shrikant Sharat Kandula <shrikantsharat.k@gmail.com>
" Used On: (G)Vim 7.3 and 7.2 on Ubuntu Maverick, Karmic and Lucid, and Windows 7
" Modeline: vim: set ft=vim et sts=4 ts=8 sw=4 :

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Return the operating system we are running
fun! <SID>qui_os()
    if has("win16") || has("win32") || has("win64")
        return "win"
    endif
    return substitute(system('uname'), "\n", "", "")
endfun

" Define the VIMFILES directory, if not already done
if !exists("$VIMFILES")
    if s:qui_os() == "win"
        let $VIMFILES="C:/tools/Vim/vimfiles"
    else
        let $VIMFILES="$HOME/.vim"
    endif
endif

" Load Pathogen bundles
set rtp+=$VIMFILES/bundle/vim-pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Is vimrc running for the first time. e.g., not run with `source`
let s:first_time = !exists('g:vimrc_done')
let g:vimrc_done = 1

set path=./**

if has('gui_running')

    if s:first_time

        if s:qui_os() == "win"
            set guifont=Consolas:h14:cANSI
        else
            set guifont=Inconsolata\ Medium\ 15
        endif

        set guioptions+=b " enable horizontal scrollbar
        set guioptions-=T " remove toolbar
        set guioptions-=t " remove tearoff from menus
        " set guioptions+=c " user console like dialogs instead of GUI ones

        set lines=32 columns=120

        " set the default colorscheme
        " colorscheme liquidcarbon
        colorscheme chance-of-storm

    endif

else
    set bg=light
    colorscheme tango
endif

" My remapping of <C-^>. If there is no alternate file, then switch to next file.
" Original: VIM Tips wiki
nnoremap <silent> <C-^> :exe 'silent! b' . (expand('#') == '' ? 'n' : ' #')<CR>

" set backup only if not using version control
if has("vms")
    set nobackup
else
    set backup
endif

" Enable File type detection
" Also load indent files, to automatically do language-dependent indenting
filetype indent on
filetype plugin on

if has('autocmd')

    " Place the autocmds in a group
    augroup shvim

    " Clear the autocmd's in the group
    autocmd!

    autocmd BufRead,BufNewFile **/knolskape/**/* setlocal noet ts=4 sw=4 sts=0 list

    " when editing a file, jump to the last known cursor position
    " Don't do it when the position id invalid or when inside an event handler
    " (happens when dropping a file on gvim)
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     exe 'normal! g`"' |
        \ endif

    augroup END

endif

" indenting settings
set tabstop=4 " Displayed size of a tab character
set softtabstop=4 " No. of spaces that make up a single indent
set shiftwidth=4 " No. of display space to be shifted per indent
set expandtab " Use spaces instead of tabs to indent

" turn on syntax highlighting
syntax on

" Make backspace act sane (i.e., non vi-compatible)
set backspace=indent,eol,start

" Swap leader and `,`
nnoremap \ ,
let mapleader = ','

" enable mouse
set mouse=a

" Hide abandoned buffers in order to not lose undo history
set hidden

" Ignore case in searches for everything (Tab completion, C-x completions
" etc.)
set ignorecase

" highlight last used search term
if s:first_time
    set hlsearch
endif

" do incremental search
set incsearch

" location where all the backups go
if s:qui_os() != "win"
    set backupdir=~/.vimbaks
endif

" Keep swap files in one location
set directory=$VIMFILES/swap//,.

" lines to save from command line history
set history=1000

" disable word-wrap
set nowrap

" Keep cursor on current column for certain jump commands
set nostartofline

" enable line numbers
set number

" show the cursor position all the time
set ruler

" display partial/incomplete commands
set showcmd

" Show a mini-menu when using Tab-completions for commands
set wildmenu

" Use / instead of \ in file name completion among other places
set shellslash

" omni completion function
set omnifunc=syntaxcomplete#Complete

" Characters used to show invisibles with `list`
" Other possible tab chars: ›‣⁍
"set list listchars=tab:›\ ,trail:∙

" Use blowfish encryption by default
if has('&cryptmethod')
    set cryptmethod=blowfish
endif

" Enable concealing everywhere
if has('conceal')

    set concealcursor=nvic

    " Toggle concealing
    nnoremap <silent> <F8> :call <SID>ToggleConceal(2)<CR>
    fun! <SID>ToggleConceal(value)
        exe 'set conceallevel=' . (&conceallevel == 0 ? a:value : 0)
    endfun

endif

" Mappings {{{

" Maps that make more sense
nnoremap Y y$
nnoremap ZZ :wa<CR>:x<CR>

" Easier way to go to normal mode and save all modified buffers
inoremap <silent> <S-CR> <ESC><CR>

" Save all modified buffers
nnoremap <silent> <CR> :call <SID>SuperEnterKey()<CR>
nnoremap <silent> <S-CR> :call <SID>SuperEnterKey()<CR>
fun! <SID>SuperEnterKey()
    if &buftype == 'quickfix'
        .cc
    else
        wa
    endif
endfun

" Map to change current directory to the directory of the current buffer
nnoremap cd :cd %:p:h<CR>:pwd<CR>

" Map in visual mode to duplicate selected stuff just below the selected stuff
vnoremap D y'>p

" Easy mapping to show only the current window.
" ... or a map to Zoom toggling if ZoomWin plugin is available
nnoremap <F9> <C-w>o

" Home key mapping
inoremap <Home> <C-o>^

" Turn off hlsearch temporarily
nnoremap <silent> <F3> :noh<CR>

" More convinient to go to command mode
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" }}}

" My status line rules!
set laststatus=2
set statusline=%f\ [%n%H%M%R%W]\ [%{&ff}]\ %y%=%b\ %l/%L\|%c%V\ %P

" My title line rules too!!
set title
"set titlestring=\{%{\ g:LAST_SESSION\ }\}+\ %m\ %f\ %h\ -\ GVIM

" * and # to work in visual mode, but search for the selected text
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

" A C command to do simple/complex calculations by evaluating the given
" expression as a python expression (with math module imported).
command! -nargs=+ C :py print <args>
py from math import *

" Replace consecutive blank lines with a single blank line
nnoremap <silent> <Leader>xx :call <SID>PurgeExtraBlankLines()<CR>
fun! <SID>PurgeExtraBlankLines()
    if getline('.') != ''
        return
    endif
    normal k
    while getline('.') == ''
        normal ddk
    endwhile
    normal jj
    while getline('.') == ''
        normal dd
    endwhile
    normal k
endfun

" Strip all trailing spaces in the whole file
nnoremap <silent> <Leader>xt :call <SID>StripTrailingSpaces()<CR>
fun! <SID>StripTrailingSpaces()
    let _s = @/
    let l = line('.')
    let c = col('.')
    %s/\s\+$//e
    let @/ = _s
    call cursor(l, c)
endfun

" Show highlighting groups for word under cursor
nnoremap <C-S-P> :call <SID>SynStack()<CR>
fun! <SID>SynStack()
    if !exists("*synstack")
        echo 'Nothing appropriate'
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfun

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
command! DiffOrig vnew | set bt=nofile | read # | 0d_ | diffthis | wincmd p | diffthis

" Text object shortcuts

" r for rectangle brackets
onoremap ar a]
onoremap ir i]

" a for angle brackets
onoremap aa a>
onoremap ia i>

" c for curly brackets
onoremap ac a}
onoremap ic i}

" Act on the next occuring text-object in the current line

fun! <SID>ObMapper(char, ...)
    let key = a:0 ? a:1 : a:char
    exe 'vnoremap <silent> in' . key . ' :<C-U>normal! f' . a:char . 'vi' . key . '<CR>'
    exe 'onoremap <silent> in' . key . ' :<C-U>normal! f' . a:char . 'vi' . key . '<CR>'
    exe 'vnoremap <silent> an' . key . ' :<C-U>normal! f' . a:char . 'va' . key . '<CR>'
    exe 'onoremap <silent> an' . key . ' :<C-U>normal! f' . a:char . 'va' . key . '<CR>'
endfun

" Next ()
call <SID>ObMapper('(', 'b')
call <SID>ObMapper('(')

" Next {}
call <SID>ObMapper('{', 'B')
call <SID>ObMapper('{', 'c')
call <SID>ObMapper('{')

" Next []
call <SID>ObMapper('[', 'r')
call <SID>ObMapper('[')

" Next <>
call <SID>ObMapper('<', 'a')
call <SID>ObMapper('<')

" Next ''
call <SID>ObMapper("'")

" Next ""
call <SID>ObMapper('"')

" Plugin settings
source $VIMFILES/bundles.vim
