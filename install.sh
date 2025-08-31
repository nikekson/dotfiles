#!/bin/sh

find -- * -maxdepth 0 -type d | while IFS= read -r dir; do
  stow --dotfiles --target="$HOME" --delete "$dir"
  stow --dotfiles --target="$HOME" "$dir"
done
