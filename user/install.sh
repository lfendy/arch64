#!/bin/bash

sudo pacman -S \
  docker \
  tmux \
  git

mkdir -p ~/projects
git clone https://github.com/lfendy-vim/dot-vim ~/projects/dot-vim
