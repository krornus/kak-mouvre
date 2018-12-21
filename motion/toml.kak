declare-option -hidden str header %{^\[+[a-zA-Z0-9_\-\.]+(?:"[^"]*")?(?:'[^']*')?\]+$}

add-highlighter shared/toml-section group
add-highlighter shared/toml-section/ regex %opt{header} 0:white+b

hook global BufCreate .*\.(toml) %{
    set-option buffer filetype toml
}

hook -group toml-section-highlight global WinSetOption filetype=toml %{
    add-highlighter window/toml-section ref toml-section
}

hook -group toml-section-hook global WinSetOption filetype=toml %{
    hook buffer -group toml-section-hooks NormalKey p toml-section-next-chunk

    map buffer normal n :select-forward-toml-section<ret>
    map buffer normal N :extend-forward-toml-section<ret>
    map buffer normal <a-n> :select-backward-toml-section<ret>
    map buffer normal <a-N> :extend-backward-toml-section<ret>
    map -docstring "toml-section chunk" buffer object c <esc>:select-surrounding-toml-section<ret>
}

hook -group toml-section-highlight global WinSetOption filetype=(?!toml).* %{
    remove-highlighter window/toml-section
}

hook -group toml-section-hook global WinSetOption filetype=(?!toml).* %{
    map buffer normal n n
    map buffer normal <a-n> <a-n>
}

define-command jump-forward-toml-section %{
    jump-forward-regex-start %opt{header}
}

define-command jump-backward-toml-section %{
    jump-backward-regex-start %opt{header}
}

create-bidirectional-movement-command jump-forward-toml-section jump-backward-toml-section toml-section 0
