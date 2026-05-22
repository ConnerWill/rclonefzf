#!/usr/bin/env bash

# rclonefzf - bash completion

_rclonefzf_complete() {
    local cur prev cword
    local -a theme_options opts long_opts short_opts

    _init_completion || return

    COMPREPLY=()

    theme_options=(
        default
        light
        tokyo-night
        neon
        catppuccin-mocha
        catppuccin-latte
        dracula
        gruvbox-dark
        gruvbox-light
        nord
        solarized-dark
        solarized-light
        rose-pine
        rose-pine-moon
        rose-pine-dawn
        onedark
        kanagawa
        github-dark
        github-light
        monokai
        material-dark
        material-light
        ayu-dark
        everforest-dark
        everforest-light
        iceberg
        papercolor-light
        papercolor-dark
        doom-one
        nightfox
        carbonfox
    )

    long_opts=(
        --help
        --help-man
        --keybindings
        --init-config
        --show-config
        --no-preview
        --theme
        --list-themes
        --preview-themes
        --verbose
        --version
    )

    short_opts=(
        -h
        -k
        -i
        -s
        -t
        -l
        -v
        -V
    )

    opts=(
        "${short_opts[@]}"
        "${long_opts[@]}"
    )

    # Complete theme names after: rclonefzf -t <TAB>
    case "${prev}" in
        -t|--theme)
            mapfile -t COMPREPLY < <(compgen -W "${theme_options[*]}" -- "${cur}")
            return 0
            ;;
    esac

    # Complete long options.
    if [[ ${cur} == --* ]]; then
        mapfile -t COMPREPLY < <(compgen -W "${long_opts[*]}" -- "${cur}")
        return 0
    fi

    # Complete short options.
    if [[ ${cur} == -* ]]; then
        mapfile -t COMPREPLY < <(compgen -W "${short_opts[*]}" -- "${cur}")
        return 0
    fi

    # If we're at position 1, show options only.
    if (( cword == 1 )); then
        mapfile -t COMPREPLY < <(compgen -W "${opts[*]}" -- "${cur}")
        return 0
    fi

    # After any recognized no-argument option, complete nothing.
    case "${prev}" in
        -h|--help|--help-man|-k|--keybindings|-i|--init-config|-s|--show-config|--no-preview|-l|--list-themes|--preview-themes|-v|--verbose|-V|--version)
            return 0
            ;;
    esac

    # Fallback: complete nothing.
    return 0
}

complete -F _rclonefzf_complete rclonefzf
