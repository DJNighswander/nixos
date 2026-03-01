#!/usr/bin/env bash

# Check if the first argument is a directory
if [ -d "$1" ]; then
  # If it is, move into it and open Neovim
  cd "$1" && nvim ./
else
  # Otherwise, pass all arguments directly to Neovim
  nvim "$@"
fi
