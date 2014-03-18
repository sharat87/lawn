" Author: Shrikant Sharat Kandula <shrikantsharat.k@gmail.com>
" Description: Display an awesome ruler. No need for a statusline.

let s:ruler = '%40(%=' . join([
            \ '%#Error#%{MixedIndentRuler()}%*',
            \ '%#Error#%{TrailingSpaceRuler()}%*',
            \ '%#Error#%{EncodingRuler()}%*',
            \ '%{InfoRuler()}',
            \ ]) . '%)'

exec 'set ruler rulerformat=' . escape(s:ruler, ' ')

fun! TrailingSpaceRuler()
    return &modifiable && search('\s$', 'nw') ? '[∙∙∙$]' : ''
endfun

fun! MixedIndentRuler()
    " Adapted from vim-airline
    return &modifiable && search('\v(^\t+ +)|(^ +\t+)', 'nw') ? '[›∙∙∙]' : ''
endfun

fun! EncodingRuler()
    return &modifiable && &fenc != 'utf-8' && &fenc != '' ? '[' . &fenc . ']' : ''
endfun

fun! InfoRuler()
    if exists('b:ruler')
        return b:ruler

    elseif &ft == 'help'
        return ':h ' . expand('%:t') . ' --' . (100 * line('.') / line('$')) . '%-- '

    elseif &ft == 'qf'
        return '‹' . getline('$') . '› quickfix'

    else
        return join([
                    \ (&modified ? '+' : ''),
                    \ substitute(bufname('%'), '^' . $HOME, '~', ''),
                    \ line('.') . ':' . col('.'),
                    \ (100 * line('.') / line('$')) . '%',
                    \ ])

    endif
endfun

" Ctrlp {{{
fun! CtrlpStatusMain(focus, byfname, regex, prev, item, next, marked)
    let b:ruler = join([
                \ '╱' . a:byfname . '╱',
                \ a:regex ? '/re' : '',
                \ a:marked == ' <->' ? '' : a:marked,
                \ '{' . a:item . '}',
                \ '∥ ctrlp',
                \ ])
endfun

let g:ctrlp_status_func = {'main': 'CtrlpStatusMain'}
" }}}

" vim: se fdm=marker :
