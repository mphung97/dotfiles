#!/bin/bash

# zsh setup
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo "Running on Linux"
	sudo apt install zsh -y
	chsh -s $(which zsh)
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

git clone https://github.com/mphung97/dotfiles-next.git ~/dotfiles
