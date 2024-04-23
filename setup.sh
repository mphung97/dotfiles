#!/bin/bash

sudo apt install zsh -y
chsh -s $(which zsh)

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# Run the following command (you will need sudo access).
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Install home-manager
# nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
# nix-channel --update

# nix-shell '<home-manager>' -A install

nix --version
# home-manager --version

# devbox install
curl -fsSL https://get.jetify.com/devbox | bash

# devbox global pull https://devbox.getfleek.dev/high
devbox global pull https://github.com/mphung97/devbox.git

echo 'eval "$(devbox global shellenv --init-hook)"' >> ~/.zshrc

source ~/.zshrc
