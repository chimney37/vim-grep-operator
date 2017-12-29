" Steve Losh's grep plugin
" try out function with <localleader>giw (grep inside word)
" operatorfunc specifies a function to be called by the g@ operator.
nnoremap <localleader>g :set operatorfunc=GrepOperator<cr>g@
" Note: In visual mode, <c-u> is used to delete from the cursor to the beginning.
" without it, : in visual mode will append '<,'> which is the range of the
" visually selected text. visualmode() is a built in vim function that returns
" one-character representing the last type of visual mode used. "v" for
" characterwise, "V" for linewise, Ctrl-v character for blockwise. 
" pressing <localleader>giw echoes char, 
" pressing <localleader>gG echoes line
vnoremap <localleader>g :<c-u>call GrepOperator(visualmode())<cr>

function! GrepOperator(type)
    "echom a:type
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif
    
    silent execute "grep! -R " . shellescape(@@) . " ."
    copen
    " :help :silent mentions sometimes screen messes up after external
    " command. use redraw function to redraw. ! clears first.
    redr!
endfunction

" Useful commands
" viw<localleader>g : visually select a word, then grep
" <localleader>g4w : grep next 4 words
" <localleader>gt) : grep until closing bracket
" <localleader>gi[ : grep inside square bracket
