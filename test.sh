#!/usr/bin/env bash
# rclone-fzf-browser
# Browse and preview rclone remotes interactively with fzf
# Requires: rclone, fzf, (optionally: tree, bat, exa/eza/lsd, glow, mdless, ...)

set -u

# ──────────────────────────────────────────────────────────────────────────────
#  CONFIGURATION
# ──────────────────────────────────────────────────────────────────────────────

# Which preview command to use (will try them in this order)
PREVIEWERS=(
    "bat --color=always --style=changes,grid --plain"
    "cat"
)

# Max depth for tree previews (when no good previewer is found)
TREE_MAXDEPTH=3

# How many items to list at once (performance vs UX tradeoff)
RCLONE_LS_LIMIT=400

# Show sizes in human-readable format?
RCLONE_HUMAN=true

# ──────────────────────────────────────────────────────────────────────────────
#  HELPERS
# ──────────────────────────────────────────────────────────────────────────────

choose_preview_cmd() {
    for cmd in "${PREVIEWERS[@]}"; do
        # extract first word (the actual binary)
        bin="${cmd%% *}"
        if command -v "${bin%% *}" >/dev/null 2>&1; then
            echo "$cmd"
            return 0
        fi
    done
    echo "tree -C -I '.git' --dirsfirst -L $TREE_MAXDEPTH"
}

PREVIEW_CMD=$(choose_preview_cmd)

human() {
    if [[ $RCLONE_HUMAN = true ]]; then
        rclone size --json "$1" 2>/dev/null |
            jq -r '.bytes | [.] | @sh' |
            numfmt --to=iec-i --format="%.2f" 2>/dev/null || echo "?"
    else
        rclone size --json "$1" 2>/dev/null |
            jq -r '.bytes // "unknown"' || echo "unknown"
    fi
}

# ──────────────────────────────────────────────────────────────────────────────
#  MAIN LOOP
# ──────────────────────────────────────────────────────────────────────────────

CURRENT=""

while true; do
    if [[ -z $CURRENT ]]; then
        # Top level → show remotes
        mapfile -t REMOTES < <(rclone listremotes --long 2>/dev/null | sed 's/:$//')

        if [[ ${#REMOTES[@]} -eq 0 ]]; then
            echo "No rclone remotes found." >&2
            exit 1
        fi

        SELECTION=$(printf '%s\n' "${REMOTES[@]}" \
            | fzf --height 60% --reverse --border --prompt="rclone remote > " \
                  --header="Select remote" \
                  --preview="rclone about {}:" \
                  --preview-window="right:50%:wrap")

        [[ -z $SELECTION ]] && exit 0

        CURRENT="${SELECTION}:"
    else
        # ── Browse inside current path ──────────────────────────────────────

        # Header line with current path + size
        size_info=$(human "$CURRENT")
        header="Path: $CURRENT    Size: $size_info"

        # List contents
        mapfile -t ITEMS < <(
            rclone lsf --dirs-first --max-depth 1 --fast-list \
                ${RCLONE_HUMAN:+"--human"} \
                --max-age 20y "$CURRENT" 2>/dev/null
        )

        if [[ ${#ITEMS[@]} -eq 0 ]]; then
            echo "Empty directory or error accessing $CURRENT" >&2
            CURRENT=""
            continue
        fi

        # Add special entries
        choices=("../" "${ITEMS[@]}")

        SELECTION=$(printf '%s\n' "${choices[@]}" \
            | fzf --height 80% --reverse --border \
                --prompt="$CURRENT > " \
                --header="$header" \
                --preview="
                    item={};
                    path=\"$CURRENT\${item%/}\";
                    if [[ \$item == ../ ]]; then
                        echo 'Go up one level';
                    elif [[ \$item == */ ]]; then
                        echo 'Directory: ' \$path;
                        rclone lsf --human --max-depth 2 --dirs-first \$path 2>/dev/null | head -n 60;
                    else
                        echo 'Previewing: ' \$path;
                        rclone cat \$path 2>/dev/null | $PREVIEW_CMD 2>/dev/null | head -n 200;
                    fi
                " \
                --preview-window="right:55%:wrap" \
                --bind 'ctrl-y:execute-silent(echo {}/ | wl-copy 2>/dev/null || xclip -sel clip 2>/dev/null)+abort' \
                --bind 'ctrl-o:execute(rclone cat {} | $PREVIEW_CMD | less -R)+abort' \
                --expect=ctrl-d,ctrl-c,esc \
                --ansi)

        key=$(echo "$SELECTION" | head -n1)
        choice=$(echo "$SELECTION" | tail -n+2)

        case $key in
            ctrl-c|esc) exit 0 ;;
            ctrl-d)     # Download selected item
                if [[ -n $choice ]]; then
                    dest="./$(basename "${choice%/}")"
                    echo "Downloading $CURRENT$choice → $dest"
                    rclone copyto "$CURRENT$choice" "$dest" --progress
                fi
                continue
                ;;
        esac

        [[ -z $choice ]] && exit 0

        if [[ $choice == ../ ]]; then
            # Go up
            CURRENT="${CURRENT%/*}/"
            [[ $CURRENT == :/ ]] && CURRENT=""
            [[ $CURRENT != */ ]] && CURRENT+="/"
        elif [[ $choice == */ ]]; then
            # Enter directory
            CURRENT="${CURRENT}${choice}"
        else
            # File selected → show preview / open / copy path etc.
            fullpath="$CURRENT$choice"

            action=$(printf "%s\n" \
                "View (cat)" \
                "Copy path to clipboard" \
                "Download here" \
                "rclone cat | less" \
                "Cancel" \
                | fzf --height 30% --reverse --border --prompt="Action for $choice > ")

            case "$action" in
                "View (cat)"*)
                    rclone cat "$fullpath" | $PREVIEW_CMD | less -R
                    ;;
                "Copy path to clipboard"*)
                    echo -n "$fullpath" | wl-copy 2>/dev/null || xclip -sel clip 2>/dev/null || pbcopy 2>/dev/null
                    echo "Copied: $fullpath"
                    ;;
                "Download here"*)
                    rclone copyto "$fullpath" "./$choice" --progress
                    ;;
                "rclone cat | less"*)
                    rclone cat "$fullpath" | less -R
                    ;;
                *) ;;
            esac
        fi
    fi
done
