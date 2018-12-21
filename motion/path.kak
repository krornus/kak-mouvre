
declare-option regex path_element %{/?(?:[^/\s]|(?<=\\\\)\s)+/?}

create-regex-movement-command path %opt{path_element}

define-command select-inner-surrounding-path %{
    evaluate-commands -save-regs /a %{
        execute-keys '"aZ'
        try %{
            select-surrounding-path
            set-register / "[^/]?(?<=.).*(?=.)[^/]"
            execute-keys "<esc>s<ret><a-:>"
        } catch %{
            execute-keys '"az<esc>'
            fail "No selections remaining"
        }
    }
}

declare-user-mode path

map -docstring "select to next path element end" global path e %{<esc>:select-forward-path<ret>}
map -docstring "extend to next path element end" global path E %{<esc>:extend-forward-path<ret>}
map -docstring "select to previous path element start" global path b %{<esc>:select-backward-path<ret>}
map -docstring "extend to previous path element start" global path B %{<esc>:extend-backward-path<ret>}
map -docstring "select surrounding path element" global path a %{<esc>:select-surrounding-path<ret>}
map -docstring "select inner path element" global path i %{<esc>:select-inner-surrounding-path<ret>}

map -docstring "path element" global object d %{<esc>:select-surrounding-path<ret>}
map -docstring "path element" global object <a-d> %{<esc>:select-inner-surrounding-path<ret>}

