#!/bin/bash

DOTFILES_DIR="$(dirname "$(realpath "$0")")"

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y \
    direnv \
    gpg-agent \
    jq \
    libreadline-dev \
    lua5.1 \
    pass \
    pinentry-tty \
    python3 \
    python3-pip \
    python3-venv \
    ripgrep \
    socat \
    tree \
    unzip \
    dtach

# curl -fsSL https://cli.coderabbit.ai/install.sh | sh
# curl -fsSL https://claude.ai/install.sh | bash

if [ "$USER" = "vscode" ]; then
    git clone https://github.com/goropikari/nvim ~/.config/nvim
    sudo apt-get update && sudo apt-get upgrade -y
fi

# Backup existing files if backup doesn't already exist
if [ -f ~/.bashrc ] && [ ! -f ~/.bashrc.bk ]; then
    cp ~/.bashrc ~/.bashrc.bk
fi

if [ -f ~/.bash_profile ] && [ ! -f ~/.bash_profile.bk ]; then
    cp ~/.bash_profile ~/.bash_profile.bk
fi
ln -fs ${DOTFILES_DIR}/.bashrc ~
ln -fs ${DOTFILES_DIR}/.bash_profile ~
ln -fs ${DOTFILES_DIR}/.bash-powerline.sh ~
ln -fs ${DOTFILES_DIR}/git/.gitignore_global ~
ln -fs ${DOTFILES_DIR}/git/.gitconfig ~
ln -fs ${DOTFILES_DIR}/git/git-completion.bash ~/.git-completion.bash
ln -fs ${DOTFILES_DIR}/git/git-prompt.sh ~/.git-prompt.sh

mkdir -p ~/.local/bin
ln -sfn "${DOTFILES_DIR}/bin" ~/.local/dotfiles_bin
