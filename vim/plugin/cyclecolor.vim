" cyclecolor.vim
" cycle through available colorschemes
"
" Maintainer: Shrikant Sharat <shrikantsharat.k@gmail.com>
" Original: by Marvin Renich <mrvn-vim@renich.org>
" Version:  1.1

" Copyright 2005, 2006 Marvin Renich
"
" Redistribution and use, with or without modification, are permitted
" provided that the following conditions are met:
"
"   1.  Redistributions in any form must retain the above copyright
"       notice, this list of conditions and the following disclaimer.
"   2.  The name of the author may not be used to endorse or promote
"       products derived from this software without specific prior
"       written permission.
"
" THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
" IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
" INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
" (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
" SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
" HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
" STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
" IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
" POSSIBILITY OF SUCH DAMAGE.

" This script is inspired by a one-liner by Tim Chase on the vim@vim.org mailing
" list in Message-ID: <42CAEC9F.7050001@thechases.com>.
"
" This script uses globpath to get all available colorschemes, not just the ones
" in the $VIMRUNTIME/colors directory. It also helps when the script does not
" set the colors_name correctly (and there are some that do not).

function! s:CycleColor(direction)

    let all_schemes = split(globpath(&rtp, 'colors/*.vim'), '\n')
    let all_schemes = map(all_schemes, 'substitute(v:val, "^.\\+/", "", "")')
    let all_schemes = map(all_schemes, 'substitute(v:val, "\\.vim$", "", "")')
    let len_schemes = len(all_schemes)

    if exists('g:colors_name')
        let current_index = index(all_schemes, g:colors_name)
        let next = (current_index + len_schemes - 1 + a:direction) % (len_schemes - 1)
    else
        let current_index = -1
        let next = 0
    endif

    let scheme = all_schemes[next]
    exec 'colorscheme ' . scheme
    let g:colors_name = scheme

endfunction

command! ColorschemeNext call s:CycleColor(1)
command! ColorschemePrev call s:CycleColor(-1)

nnoremap <silent> z. :ColorschemeNext<CR>
nnoremap <silent> z, :ColorschemePrev<CR>

" vim: set et sts=4 sw=4 :
