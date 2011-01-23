" Author: Shrikant Sharat Kandula <shrikantsharat.k@gmail.com>
" Used On: (G)Vim 7.3 and 7.2 on Ubuntu Maverick, Karmic and Lucid, and Windows 7
" Modeline: vim: set ft=vim et sts=4 ts=8 sw=4 fdm=marker :

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Utilities {{{

" Return the operating system we are running
fun! <SID>qui_os()
    if has("win16") || has("win32") || has("win64")
        return "win"
    endif
    return substitute(system('uname'), "\n", "", "")
endfun

" Define the VIMFILES directory, if not already done
if !exists('$VIMFILES')
    if s:qui_os() == 'win'
        let $VIMFILES = 'C:/tools/Vim/vimfiles'
    else
        let $VIMFILES = $HOME . '/.vim'
    endif
endif

" Is vimrc running for the first time. e.g., not run with `source`
let s:first_time = !exists('g:vimrc_done')
let g:vimrc_done = 1

" Bundle: git://github.com/tpope/vim-pathogen.git
" Load Pathogen bundles
set rtp+=$VIMFILES/bundle/vim-pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#runtime_append_all_bundles('bundle-local')
call pathogen#helptags()

set path=./**

" }}}

" Settings {{{

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

" Use `,` as the leader, and space for the default functionality of `;` and
" `,`
nnoremap <Space> ;
nnoremap <S-Space> ,
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
    nnoremap <silent> <F3> :call <SID>ToggleConceal(2)<CR>
    fun! <SID>ToggleConceal(value)
        exe 'set conceallevel=' . (&conceallevel == 0 ? a:value : 0)
    endfun

endif

" My status line rules!
set laststatus=2
set statusline=%f\ [%n%H%M%R%W]\ [%{&ff}]\ %y%=%b\ %l/%L\|%c%V\ %P

" My title line rules too!!
set title
"set titlestring=\{%{\ g:LAST_SESSION\ }\}+\ %m\ %f\ %h\ -\ GVIM

" }}}

" Mappings {{{

" Maps that make more sense
nnoremap Y y$
nnoremap ZZ :wa<CR>:x<CR>

" Easier way to go to normal mode and save all modified buffers
inoremap <silent> <S-CR> <ESC>

" A use for the unused Arrow keys :)
nnoremap <Up> <C-y>
nnoremap <Down> <C-e>
vnoremap <Up> <C-y>
vnoremap <Down> <C-e>

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
nnoremap <silent> <Leader>h :noh<CR>

" More convinient to go to command mode
nnoremap ; :
vnoremap ; :

" F1 is goddamn close to <ESC>. I don't want to see help with F1.
noremap <F1> <Nop>
inoremap <F1> <Nop>

" * and # to work in visual mode, but search for the selected text
vnoremap * y/<C-R>"<CR>
vnoremap # y?<C-R>"<CR>

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

" }}}

" Custom Commands {{{

" A C command to do simple/complex calculations by evaluating the given
" expression as a python expression (with math module imported).
command! -nargs=+ C :py print <args>
py from math import *

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
command! DiffOrig vnew | set bt=nofile | read # | 0d_ | diffthis | wincmd p | diffthis

" }}}

" Plugins {{{

" Bundle: git://github.com/tpope/vim-surround.git with git
" Bundle: git://github.com/tpope/vim-abolish.git
" Bundle: git://github.com/mileszs/ack.vim.git
" Bundle: git://github.com/vim-scripts/AutoClose.git
" Bundle: git://github.com/vim-scripts/DirDiff.vim.git
" Bundle: git://github.com/tpope/vim-fugitive.git
" Bundle: git://github.com/michaeljsmith/vim-indent-object.git
" Bundle: git://github.com/vim-scripts/matchit.zip.git
" Bundle: git://github.com/tpope/vim-repeat.git
" Bundle: git@github.com:sharat87/snipmate.vim.git
" Bundle: git://github.com/tomtom/tcomment_vim.git
" Bundle: git://github.com/tpope/vim-unimpaired.git
" Bundle: git://github.com/vim-scripts/ZoomWin.git
" Bundle: git://github.com/vim-scripts/ManPageView.git
" Bundle: git://github.com/tpope/vim-markdown.git
" Bundle: git://github.com/ehamberg/vim-cute-python.git
" Bundle: git://github.com/pangloss/vim-javascript.git

" Bundle: https://github.com/vim-scripts/Command-T.git
" Run: cd ruby/command-t
" Run: ruby extconf.rb && make
" Command-T launcher
nnoremap <silent> <Leader>f :CommandT<CR>
nnoremap <Leader>F :CommandTFlush<CR><CR><Leader>f

" Bundle: git://github.com/scrooloose/nerdtree.git
" Convenience map for toggling NerdTree window
nnoremap <silent> <F4> :NERDTreeToggle<CR>
" Set the location of bookmarks for nerdtree
let g:NERDTreeBookmarksFile = '$HOME/.vim/nerdtree-bookmarks'

" #Bundle: https://sharat87@github.com/sharat87/sessionman.vim.git
" Bundle: git://github.com/sharat87/sessionman.vim.git
" Map to open a session
nnoremap <Leader>n :SessionOpen<Space>

" Bundle: http://bitbucket.org/sharat87/vim-looks
" Themes for use with looks.vim
let g:looks = {}
let g:looks.mac = {
            \ ':colorscheme': 'mac_classic',
            \ '&guifont': 'Inconsolata Medium 15',
            \ '&cursorline': 1
            \ }
let g:looks.mac._map = 'm'
let g:looks.calmDark = { ':colorscheme': 'lucius', '&guifont': 'Consolas 13', '&cursorline': 0 }
let g:looks.calmDark._map = 'd'

" Bundle: git://github.com/vim-scripts/Conque-Shell.git
" Conque options
let g:ConqueTerm_CWInsert = 1 " Use <C-W> in insert mode as if it were hit in normal mode
let g:ConqueTerm_TERM = 'vt100' " The terminal type Conque identifies itself as, to the shell
let g:ConqueTerm_Syntax = 'conque'

" Bundle: git://github.com/vim-scripts/vimwiki.git
" vimwiki settings
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_menu = '&Plugin.Vim&wiki'
let g:vimwiki_use_mouse = 1
let g:vimwiki_browsers = ['/usr/bin/google-chrome']
let nested_syntaxes = { 'python': 'python' }
let g:vimwiki_list = [
    \ { 'path': '~/knolskape/vnotes', 'nested_syntaxes': nested_syntaxes }
    \]

" Bundle: http://bitbucket.org/kotarak/vimclojure
" VimClojure preferences
let vimclojure#ParenRainbow = 1

" Bundle: git://github.com/tpope/vim-ragtag.git
" Ragtag preferences
inoremap <M-o>       <Esc>o
inoremap <C-j>       <Down>
let g:ragtag_global_maps = 1

" Bundle: http://bitbucket.org/sjl/gundo.vim
" Gundo Toggle
nnoremap <F10> :GundoToggle<CR>

" Bundle: git://github.com/Shougo/vimproc.git
" Run: make -f make_gcc.mak

" Bundle: git://github.com/ujihisa/quickrun.git
" Quickrun settings
let g:quickrun_config = { '_': {} }

let g:quickrun_config.tcl = { 'command': 'tclsh' }

" let g:quickrun_config._.exec = 'time %c %s %a'
" let g:quickrun_config._.runmode = 'async:remote:vimproc'
let g:quickrun_config._.running_mark = '{RandomRunningVerb()}'
" A function that gives a random verb-y string to display when a program is
" running. Just for fun :)
fun! RandomRunningVerb()
    if !has('python')
        return ':-)'
    endif
    redir => verb
python <<EOPY
verbs = (
    'Calculating awesomeness',
    'Collecting unicorn blood',
    'Defining absurdity',
    'Locating the elixir of pure geniusness',
    'Destroying insane amounts of sanity',
    'Detecting behavioral patterns',
    'Digging with the dwarves',
    'Evaluating next generation gene pool',
    'Generating Like-able creatures',
    'Innovating ridiculousness',
    'Looking for the elves',
    'Obeying your wish, as my command',
    'Recalculating astronomy',
    'Running the marathon',
    'Swimming with the bytes',
)
from random import choice
print '%s...' % choice(verbs)
EOPY
    redir END
    return verb
endfun

" Source evim.vim if running as evim
if v:progname =~? "evim"
    source $VIMFILES/evim.vim
endif

" }}}
