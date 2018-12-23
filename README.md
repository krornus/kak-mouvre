# kak-mouvre
Actually, it's pronounced "mouv"

# Install
Place in autoload or use [plug.kak](https://github.com/andreyorst/plug.kak).

# Overview
mouvre provides helper commands for defining custom movements. The following terminology is employed for commands:
    "jump" implies the cursor moves to a location and reduces the selection to the cursor.
        Example: `gj`
    "select" implies the cursor moves to a location and selects from the previous location to current location.
        Example: `w`
    "extend" impales the cursor moves to a location and selects from the previous location to current location.
        Example: `W`

# TL;DR
The following commands are provided with the plugin:
```
    jump-forward-regex-start
    jump-forward-regex-end
    jump-backward-regex-start
    jump-backward-regex-end
    jump-start
    jump-end

    select-forward-regex-start
    select-forward-regex-end
    select-backward-regex-start
    select-backward-regex-end
    select-start
    select-end

    extend-forward-regex-start
    extend-forward-regex-end
    extend-backward-regex-start
    extend-backward-regex-end
    extend-start
    extend-end

    extend-to-offset
    select-to-offset

    extend-by-command
    select-by-command

    create-movement-command
    create-bidirectional-movement-command
    create-regex-movement-command

    search-no-wrap
    reverse-search-no-wrap
```

# Plugins
Additionally, two filetype plugins are provided for git-style diffs and for the toml filetype.
The git-diff plugin creates bindings for moving between diff chunks,
and the toml filetype creates bindings for moving between table sections
There is also a path user mode created, which creates movement bindings for paths

# Documentation
**(jump|select|extend)-forward-regex-start** <regex>
    (Jump|select|extend) forward to next match for <regex> (does not wrap)
    Cursor will be placed at the start of the regex match

**(jump|select|extend)-forward-regex-end** <regex>
    (Jump|select|extend) forward to next match for <regex> (does not wrap)
    Cursor will be placed at the end of the regex match

**(jump|select|extend)-backward-regex-start** <regex>
    (Jump|select|extend) backward to next match for <regex> (does not wrap)
    Cursor will be placed at the start of the regex match

**(jump|select|extend)-backward-regex-end** <regex>
    (Jump|select|extend) backward to next match for <regex> (does not wrap)
    Cursor will be placed at the end of the regex match

**(jump|select|extend)-start**
    (Jump|select|extend) to the start of the buffer

**(jump|select|extend)-end**
    (Jump|select|extend) to the end of the buffer

**extend-to-offset** <offset>
    Extend current selection to byte-offset <offset>

**select-to-offset** <offset>
    Select from cursor to byte-offset <offset>

**extend-by-command** <command> ...
    Extends current selection to the point at which the cursor ends after executing <command>

**select-by-command** <command> ...
    Select from current location to the point at which the cursor ends after executing <command>


**create-movement-command** <command> <partial-name> <params>
    Creates two new movement commands which make use of <command>
    The two commands are:
        select-<partial-name>
        extend-<partial-name>
    They will select or extend from the current selection to the location
    reached by <command>
    The two commands will require <params> argument count

**create-bidirectional-movement-command** <fwd-command> <bkwd-command> <partial-name> <params>
    Creates five new movement commands which make use of <fwd-command> and <bkwd-command>
    The five commands are:
        select-forward-<partial-name>
        extend-forward-<partial-name>
        select-backward-<partial-name>
        extend-backward-<partial-name>
        select-surrounding-<partial-name>

    The commands will require <params> argument count

**create-regex-movement-command** <partial-name> <regex>
    Create a bidirectional movement commands based on a regex string
    The following commands will be created after calling this command:
        jump-forward-<partial-name>
        jump-backward-<partial-name>
        select-forward-<partial-name>
        extend-forward-<partial-name>
        select-backward-<partial-name>
        extend-backward-<partial-name>
        select-surrounding-<partial-name>

**search-no-wrap**
    Performs a forward regex search, but fails instead of wrapping

**reverse-search-no-wrap**
    Performs a reverse regex search, but fails instead of wrapping
