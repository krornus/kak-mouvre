# TODO: support not git diff also

declare-option -hidden str gitdiff_head "^diff\s+--git\s+((?:(?:[^\s])|(\\\s))+)\s+((?:(?:[^\s])|(\\\s))+)$"

add-highlighter shared/diff-chunk group
add-highlighter shared/diff-chunk/ regex %opt{gitdiff_head} 0:white+b

hook -group diff-chunk-highlight global WinSetOption filetype=diff %{
    add-highlighter window/diff-chunk ref diff-chunk
}

hook -group diff-chunk-hook global WinSetOption filetype=diff %{
    create-bidirectional-movement-command jump-forward-diff-chunk jump-backward-diff-chunk diff-chunk 0

    map buffer normal n :select-forward-diff-chunk<ret>
    map buffer normal N :extend-forward-diff-chunk<ret>
    map buffer normal <a-n> :select-backward-diff-chunk<ret>
    map buffer normal <a-N> :extend-backward-diff-chunk<ret>
    map -docstring "diff-chunk chunk" buffer object c <esc>:select-surrounding-diff-chunk<ret>
}

hook -group diff-chunk-highlight global WinSetOption filetype=(?!diff).* %{
    remove-highlighter window/diff-chunk
}

hook -group diff-chunk-hook global WinSetOption filetype=(?!diff).* %{
    map buffer normal n n
    map buffer normal <a-n> <a-n>
}

define-command jump-forward-diff-chunk %{
    jump-forward-regex-start %opt{gitdiff_head}
}

define-command jump-backward-diff-chunk %{
    jump-backward-regex-start %opt{gitdiff_head}
}

