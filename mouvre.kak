################################################################
#                                                              #
# Creates new ways to define kakoune-style motion commands     #
#   i.e. given a command which moves to a point in the file    #
#   create a way to select from cursor->new position           #
#   create a way to extend selection from cursor->new position #
#                                                              #
# The main commands provided are:                              #
#   create-movement-command                                    #
#   (select|extend)-(forward|backward)-regex-(start|end)       #
#   (select|extend)-by-command                                 #
#                                                              #
################################################################

define-command -params 1 extend-to-offset -docstring %{
extend-to-offset <offset>
    Extend current selection to byte-offset <offset>
} %{
    evaluate-commands %{
        evaluate-commands %sh{
            if [ $kak_cursor_byte_offset -lt $1 ]; then
                offset=$(($1-$kak_cursor_byte_offset))
                echo execute-keys "${offset}L"
            elif [ $kak_cursor_byte_offset -gt $1 ]; then
                offset=$(($kak_cursor_byte_offset-$1))
                echo execute-keys "${offset}H"
            fi
        }
    }
}

define-command -params 1 select-to-offset -docstring %{
select-to-offset <offset>
    Select from cursor to byte-offset <offset>
} %{
    evaluate-commands %{
        execute-keys ";"
        extend-to-offset %arg{1}
    }
}

define-command -params 1.. extend-by-command -docstring %{
extend-by-command <command> ...
    Extends current selection to the point at which the cursor ends after executing <command>
} %{
    evaluate-commands -itersel -save-regs ab %{
        execute-keys '"aZ;'
        evaluate-commands %arg{@}
        set-register b %val{cursor_byte_offset}
        execute-keys '"az'
        extend-to-offset %reg{b}
    }
}

define-command -params 1.. select-by-command -docstring %{
select-by-command <command> ...
    Select from current location to the point at which the cursor ends after executing <command>
} %{
    evaluate-commands %{
        execute-keys ";"
        extend-by-command %arg{@}
    }
}

define-command -params 1 jump-forward-regex-start -docstring %{
jump-forward-regex-start <regex>
    Jump forward to next match for <regex> (does not wrap)
    Cursor will be placed at the start of the regex match
} %{
    evaluate-commands -itersel %{
        try %{
            search-no-wrap %arg{1}
            execute-keys "<a-;>;"
        } catch %{
            #jump-end
            fail "No selections remaining"
        }
    }
}

define-command -params 1 jump-forward-regex-end -docstring %{
jump-forward-regex-end <regex>
    Jump forward to next match for <regex> (does not wrap)
    Cursor will be placed at the end of the regex match
} %{
    evaluate-commands -itersel %{
        try %{
            search-no-wrap %arg{1}
            execute-keys ";"
        } catch %{
            #jump-end
            fail "No selections remaining"
        }
    }
}

define-command -params 1 jump-backward-regex-start -docstring %{
jump-backward-regex-start <regex>
    Jump backward to next match for <regex> (does not wrap)
    Cursor will be placed at the start of the regex match
} %{
    evaluate-commands -itersel %{
        try %{
            reverse-search-no-wrap %arg{1}
            execute-keys "<a-;>;"
        } catch %{
            #jump-start
            fail "No selections remaining"
        }
    }
}

define-command -params 1 jump-backward-regex-end -docstring %{
jump-backward-regex-end <regex>
    Jump backward to next match for <regex> (does not wrap)
    Cursor will be placed at the end of the regex match
} %{
    evaluate-commands -itersel %{
        try %{
            reverse-search-no-wrap %arg{1}
            execute-keys ";"
        } catch %{
            #jump-start
            fail "No selections remaining"
        }
    }
}

define-command -command-completion -params 3 create-movement-command -docstring %{
create-movement-command <command> <partial-name> <params>
    Creates two new movement commands which make use of <command>
    The two commands are:
        select-<partial-name>
        extend-<partial-name>
    They will select or extend from the current selection to the location
    reached by <command>
    The two commands will require <params> argument count
} %{
    evaluate-commands %sh{
        echo "
        define-command -params $3 select-$2 %{
            select-by-command $1 %arg{1}
        }
        define-command -params $3 extend-$2 %{
            extend-by-command $1 %arg{1}
        }"
    }
}

create-movement-command jump-forward-regex-start forward-regex-start 1
create-movement-command jump-forward-regex-end forward-regex-end 1
create-movement-command jump-backward-regex-start backward-regex-start 1
create-movement-command jump-backward-regex-end backward-regex-end 1

define-command jump-start -docstring %{
jump-start
Jump to the start of the buffer
} %{
    execute-keys "gk<a-h>;"
}

define-command jump-end -docstring %{
jump-end
Jump to the end of the buffer
}%{
    execute-keys "gj<a-l>;"
}

define-command -params 1 search-no-wrap -docstring %{
search-no-wrap
Performs a forward regex search, but fails instead of wrapping
} %{
    evaluate-commands -save-regs ab/ %{

        set-register a %val{cursor_byte_offset}
        set-register / %arg{1}
        execute-keys '"bZ'
        try %{ execute-keys 'n<a-:>' } catch %{ fail 'No selections remaining' }

        evaluate-commands %sh{
            kak_cursor_byte_offset=$(echo $kak_cursor_byte_offset | tr -d "'")
            kak_reg_a=$(echo $kak_reg_a | tr -d "'")
            if [ $kak_cursor_byte_offset -le $kak_reg_a ]; then
                echo 'execute-keys %{"bz}'
                echo 'fail "No selections remaining"'
            fi
        }
    }
}

define-command -params 1 reverse-search-no-wrap -docstring %{
reverse-search-no-wrap
Performs a reverse regex search, but fails instead of wrapping
} %{
    evaluate-commands -save-regs ab/ %{
        set-register a %val{cursor_byte_offset}
        set-register / %arg{1}
        execute-keys '"bZ'
        try %{ execute-keys '<a-n><a-:>' } catch %{ fail 'No selections remaining' }

        evaluate-commands %sh{
            kak_cursor_byte_offset=$(echo $kak_cursor_byte_offset | tr -d "'")
            kak_reg_a=$(echo $kak_reg_a | tr -d "'")
            if [ $kak_cursor_byte_offset -ge $kak_reg_a ]; then
                echo 'execute-keys %{"bz}'
                echo 'fail "No selections remaining"'
            fi
        }
    }
}
