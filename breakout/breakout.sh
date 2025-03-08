#!/bin/sh
echo -ne '\033c\033]0;breakout\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/breakout.x86_64" "$@"
