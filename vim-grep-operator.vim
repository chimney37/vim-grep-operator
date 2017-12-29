" Modified vesrion of steve losh's grep plugin
" try out function with <localleader>giw (grep inside word)
" operatorfunc specifies a function to be called by the g@ operator.
nnoremap <localleader>g :set operatorfunc=<SID>GrepOperator<cr>g@
" note: in visual mode, <c-u> is used to delete from the cursor to the beginning of the command line.
" without it, : in visual mode will append '<,'> to the command line which is the range of the
" visually selected text. visualmode() is a built in vim function that returns
" one-character representing the last type of visual mode used. "v" for
" characterwise, "v" for linewise, ctrl-v character for blockwise. 
" pressing <localleader>giw echoes char, 
" pressing <localleader>gg echoes line
vnoremap <localleader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    "echom a:type
    " save the contents of the unnamed register before we yank
    let saved_unnamed_register = @@
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    elseif a:type ==# 'V'
        "h is to not include ^@ (null character).
        normal! `<v`>hy
    else
        return
    endif
    "echom shellescape(@@)
    silent execute "grep! -R " . shellescape(@@) . " ."
    copen
    " :help :silent mentions sometimes screen messes up after external
    " command. use redraw function to redraw. ! clears first.
    redr!
    " restore the contents of the unnamed register 
    let @@ = saved_unnamed_register 
endfunction

" Useful commands
" viw<localleader>g : visually select a word, then grep
" <localleader>g4w : grep next 4 words
" <localleader>gt) : grep until closing bracket
" <localleader>gi[ : grep inside square bracket
