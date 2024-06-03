function DetectGoHtmlTmpl()
    if expand('%:e') == "html" && search("{{") != 0
        setfiletype gohtmltmpl
    endif
endfunction

function! DebugMessage(message)
    echo "DEBUG: " . a:message
endfunction

augroup filetypedetect
    " gohtmltmpl
    au BufRead,BufNewFile *.html call DetectGoHtmlTmpl()
augroup END

" Automatically encrypt new files
" autocmd BufNewFile *.md.gpg call g:GPGInitFile()
" Automatically initialize new files with GnuPG encryption
autocmd BufNewFile *.html call gnupg#init(1)

au BufRead,BufNewFile *.md.gpg set filetype=markdown
