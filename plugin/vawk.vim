"
" vawk.vim - Awk wrapper and shorthand functions
"
" Maintainer: Tom Ryder <http://www.sanctum.geek.nz/>
"

"
" Wrapper to prevent overloading and signal our presence, and check we're not
" in compatible mode or running a version of Vim that's too old.
"
if exists('g:loaded_vawk') || &compatible || v:version < 700
    finish
endif
let g:loaded_vawk = 1

"
" Default separator is blank, which will inspire Awk to just use whitespace,
" which will be what people want most of the time.
"
let g:vawksep = ''

"
" Run an arbitrary Awk command on the selected text.
"
function! s:Vawk(start, end, cmdline)
    let l:runline = a:cmdline
    let l:runopts = []
    if g:vawksep != ''
        let l:sep = g:vawksep == '!' ? '\!' : g:vawksep
        let l:runopts += ['-F ' . shellescape(l:sep)]
    endif
    execute a:start . ',' . a:end . '!awk ' . join(l:runopts, ' ') . ' ' shellescape(l:runline)
endfunction

"
" Parse a string representing columns and ranges of columns into a list of
" columns.
"
function! s:Vparse(cols)
    let l:collist = []
    for l:col in split(a:cols, ',')
        if l:col =~ '\m^[0-9]\+$'
            let l:collist += [l:col]
        elseif l:col =~ '\m^[0-9]\+-[0-9]\+$'
            let l:lower = matchstr(l:col, '\m[0-9]\+', 0, 1)
            let l:upper = matchstr(l:col, '\m[0-9]\+', 0, 2)
            if l:lower < l:upper
                let l:collist += range(l:lower, l:upper)
            endif
        endif
    endfor
    return l:collist
endfunction

"
" Abstract filter for Vonly and Vcut.
"
function! s:Vfilter(start, end, cols, equiv, logic)
    let l:collist = s:Vparse(a:cols)
    let l:cmdline = '{for (i = 1; i <= NF; i++) {'
    let l:cmdline .= 'if (i ' . a:equiv . ' ' . join(l:collist, ' ' . a:logic . ' i ' . a:equiv . ' ') . ') '
    let l:cmdline .= 'printf("\%s\%s", $i, (i \!= NF) ? FS : "")};print ""}'
    call s:Vawk(a:start, a:end, l:cmdline)
endfunction

"
" Print only the specified columns.
"
function! s:Vonly(start, end, cols)
    call s:Vfilter(a:start, a:end, a:cols, '==', '||')
endfunction

"
" Print everything but the specified columns.
"
function! s:Vcut(start, end, cols)
    call s:Vfilter(a:start, a:end, a:cols, '\!=', '&&')
endfunction

"
" Define commands.
"
command! -range=% -nargs=* Vawk call <SID>Vawk(<line1>, <line2>, <q-args>)
command! -range=% -nargs=* Vcut call <SID>Vcut(<line1>, <line2>, <f-args>)
command! -range=% -nargs=* Vonly call <SID>Vonly(<line1>, <line2>, <f-args>)

