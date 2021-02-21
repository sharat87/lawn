" Author: Shrikant Kandula (original by Taylon Silmer)
" About: A GUI-only light colorscheme with dull colors and good contrast.

hi clear
syntax reset

let g:colors_name = expand('<sfile>:t:r')

if &background ==# 'light'
	hi Normal       gui=none       guifg=#1b1f21 guibg=#fffefc

	" Search
	hi IncSearch    gui=underline  guifg=#555753 guibg=#fce94f
	hi Search       gui=none       guifg=#555753 guibg=#fce94f

	" Messages
	hi ErrorMsg     gui=bold       guifg=#eeeeec guibg=#cc0000
	hi WarningMsg   gui=bold       guifg=#eeeeec guibg=#cc0000
	hi ModeMsg      gui=bold       guifg=#2e3436
	hi MoreMsg      gui=none       guifg=#204a87
	hi Question     gui=none       guifg=#4e9a06

	" Split area
	hi StatusLine   gui=none       guifg=#eeeeec guibg=#3465a4
	hi StatusLineNC gui=none       guifg=#eeeeec guibg=#729fcf
	hi VertSplit    gui=none       guifg=#204a87 guibg=#204a87
	hi WildMenu     gui=none       guifg=#2e3436 guibg=#eeeeec

	" Diff
	hi DiffText     gui=bold       guifg=#2e3436 guibg=#ad7fa8
	hi DiffChange   gui=none       guifg=bg      guibg=#ad7fa8
	hi DiffDelete   gui=none       guifg=bg      guibg=#eeeeec
	hi DiffAdd      gui=none       guifg=#3465a4 guibg=#eeeeec

	" Cursor
	hi Cursor       gui=none       guifg=#eeeeec guibg=#8c008a
	hi MatchParen   gui=bold       guifg=black   guibg=#bdf5fc

	" Fold
	hi Folded       gui=none       guifg=#555753 guibg=#eeeeec
	hi FoldColumn   gui=none       guifg=#888a85 guibg=#eeeeec

	" Popup Menu
	hi PMenu        guifg=#eeeeec  guibg=#555753
	hi PMenuSel     guifg=#2e3436  guibg=#eeeeec
	hi PMenuSBar    guifg=#2e3436  guibg=#eeeeec
	hi PMenuThumb   guifg=#2e3436  guibg=#eeeeec

	" Other
	hi Directory    gui=none       guifg=#204a87
	hi LineNr       gui=none       guifg=#888a85 guibg=#eeeeec
	hi CursorLineNr gui=bold       guifg=#a40000 guibg=#e0e0e0
	hi NonText      gui=none       guifg=#bfc4ba guibg=#fffaf8
	hi SpecialKey   gui=none       guifg=#ebe1ed
	hi Title        gui=bold       guifg=#3465a4
	hi Visual       gui=none       guifg=#eeeeec guibg=#729fcf
	hi ColorColumn  gui=none       guifg=#555753 guibg=#eeeeec
	hi CursorLine   gui=none       guibg=#f4f4f4
	hi Conceal             guifg=#FF0099
	hi SignColumn   gui=none       guifg=#FF0099 guibg=#eeeeec

	" Syntax group
	hi Comment      gui=italic       guifg=#888a85
	hi Constant     gui=bold       guifg=#cc0000
	hi Error        gui=none       guifg=#ffbbbb guibg=#cc0000
	hi SpellBad     term=underline gui=undercurl guisp=#ef2929
	hi Identifier   gui=none       guifg=#3465a4
	hi Ignore       gui=none       guifg=bg
	hi PreProc      gui=none       guifg=#75507b
	hi Special      gui=none       guifg=#75507b
	hi Statement    gui=none       guifg=#af8401
	hi Todo         gui=bold,italic,underline       guifg=#ef2929
	hi Type         gui=none       guifg=#4e9a06
	hi Underlined   gui=none       guifg=#3465a4
	hi String       gui=none       guifg=#a40000
	hi Number       gui=none       guifg=#3465a4
	hi DebugWords   gui=underline  guibg=#999999

	hi CtrlPPrtBase  gui=bold guifg=#4e9a06
	hi CtrlPMatch  gui=bold guifg=#ff0099
	hi CtrlPMode1  gui=bold guifg=#fccb3a guibg=#3465a4
	hi CtrlPMode2  gui=bold guifg=#9bfc41 guibg=#3465a4

	" Vimscript
	hi vimCommentTitle guifg=black gui=italic
	hi link vimCommentString Comment

	" Markdown
	hi markdownItalic gui=italic
	hi markdownBold gui=bold
	hi link markdownCode String
	hi link markdownCodeBlock Special

else
	hi Normal guibg=#2E3436 guifg=#eeeeec

	hi CursorLine gui=none guibg=#393d44
	hi Cursor gui=none guibg=White guifg=Black

	hi Folded guibg=#4D585B guibg=#d2d2d2

	hi Comment gui=italic guifg=#6d7e8a ctermfg=Grey
	hi Todo term=bold guifg=#EBC450
	hi Constant guifg=#8ae234
	hi Type guifg=#8AE234
	hi Function gui=bold guifg=#9BCF8D
	hi Statement guifg=#729FCF
	hi Identifier guifg=#AD7FA8
	hi PreProc guifg=#e9ba6e
	hi Special term=underline guifg=#5EAFE5

	hi Search guibg=#81ABBD

endif

hi link GitGutterAdd DiffAdd
hi link GitGutterDelete DiffDelete
