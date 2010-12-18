" Bundle: git://github.com/tpope/vim-pathogen.git

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
" Bundle: git://github.com/Shougo/vimproc.git
" Bundle: git://github.com/vim-scripts/ZoomWin.git
" Bundle: git://github.com/vim-scripts/ManPageView.git
" Bundle: git://github.com/tpope/vim-markdown.git
" Bundle: git://github.com/ehamberg/vim-cute-python.git
" Bundle: git://github.com/pangloss/vim-javascript.git

" Bundle: git://github.com/sharat87/GotoFile.git
" Launch GotoFile
nnoremap <silent> <C-n> :GF<CR>

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
