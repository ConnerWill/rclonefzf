#!/usr/bin/env bash

# rclonefzf - bash completion

_rclonefzf_complete() {
    local cur prev words cword
    _init_completion || return

    COMPREPLY=()

    # Complete --long-options
    if [[ ${cur} == --* ]]; then
        COMPREPLY=( $(compgen -W "--help --keybindings --init-config --show-config --verbose --version" -- "${cur}") )
        return
    fi

    # Complete -short options
    if [[ ${cur} == -* ]]; then
        COMPREPLY=( $(compgen -W "-h -k -v -V" -- "${cur}") )
        return
    fi

    # If we're at position 1 (first word after command) → show options only
    if (( cword == 1 )); then
        local opts="-h --help -k --keybindings --init-config --show-config -v --verbose -V --version"
        COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
        return 0
    fi

    # After any recognized option → nothing more
    case "${prev}" in
        -h|--help|-k|--keybindings|--init-config|--show-config|-v|--verbose|-V|--version)
            return 0
            ;;
    esac

    # Fallback: nothing
    return 0
}

complete -F _rclonefzf_complete rclonefzf
