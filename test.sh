#!/usr/bin/env bash



list_remotes(){
  rclone listremotes
}

REMOTE="$(fzf <<<"$(list_remotes)")"

rclone lsf --recursive --max-depth 10 "${REMOTE}" | fzf --preview "rclone cat '${REMOTE}{}'"
