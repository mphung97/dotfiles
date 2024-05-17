#!/bin/bash
# brew setup
# Install command
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# - Run these two commands in your terminal to add Homebrew to your PATH:
# Check if the system is Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Running on macOS"

# Check if the system is Linux
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Running on Linux"

    # 404 Not Found [IP: 91.189.95.83 80]
		# sudo add-apt-repository --remove ppa:webupd8team/ppa
		# sudo apt update
		sudo apt-get install build-essential
else
    echo "Unsupported operating system"
fi

# brew install
brew bundle install --file=~/dotfiles/Brewfile

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# stow
rm -rf ~/.zshrc
cd ~/dotfiles
stow .

