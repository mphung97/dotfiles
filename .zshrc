# initialize apps
# brew
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
# atuin
if [[ $options[zle] = on ]]; then
  eval "$(atuin init zsh )"
fi
# zoxide
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# a script to install a specific version of a formula from homebrew-core
# USAGE: brew-switch <formula> <version>
function brew-switch {
  local _formula=$1
  local _version=$2

  # fail for missing arguments
  if [[ -z "$_formula" || -z "$_version" ]]; then
    echo "USAGE: brew-switch <formula> <version>"
    return 1
  fi

  # ensure 'gh' is installed
  if [[ -z "$(command -v gh)" ]]; then
    echo ">>> ERROR: 'gh' must be installed to run this script"
    return 1
  fi

  # find the newest commit for the given formula and version
  # NOTE: we get the URL, rather than the SHA, because sometimes the commit belongs to an older repo
  local _commit_url=$(
    gh search commits \
      --owner "Homebrew" \
      --repo "homebrew-core" \
      --limit 1 \
      --sort "committer-date" \
      --order "desc" \
      --json "url" \
      --jq ".[0].url" \
      "\"${_formula}\" \"${_version}\""
  )

  # fail if no commit was found
  if [[ -z "$_commit_url" ]]; then
    echo "ERROR: No commit found for ${_formula}@${_version}"
    return 1
  else
    echo "INFO: Found commit ${_commit_url} for ${_formula}@${_version}"
  fi

  # get the 'raw.githubusercontent.com' URL from the commit URL
  local _raw_url_base=$(
    echo "$_commit_url" |
    sed -E 's|github.com/([^/]+)/([^/]+)/commit/(.*)|raw.githubusercontent.com/\1/\2/\3|'
  )

  local _formula_path="/tmp/${_formula}.rb"

  # download the formula file from the commit
  echo ""
  local _repo_path="Formula/${_formula:0:1}/${_formula}.rb"
  local _raw_url="${_raw_url_base}/${_repo_path}"
  echo "INFO: Downloading ${_raw_url}"
  if ! curl -fL "$_raw_url" -o "$_formula_path"; then
    echo "WARNING: Download failed, trying OLD formula path"
    echo ""
    _repo_path="Formula/${_formula}.rb"
    _raw_url="${_raw_url_base}/${_repo_path}"
    echo "INFO: Downloading ${_raw_url}"
    if ! curl -fL "$_raw_url" -o "$_formula_path"; then
      echo "WARNING: Download failed, trying ANCIENT formula path"
      echo ""
      _repo_path="/Library/Formula/${_formula}.rb"
      _raw_url="${_raw_url_base}/${_repo_path}"
      echo "INFO: Downloading ${_raw_url}"
      if ! curl -fL "$_raw_url" -o "$_formula_path"; then
        echo "ERROR: Failed to download ${_formula} from ${_raw_url}"
        return 1
      fi
    fi
  fi

  # if the formula is already installed, uninstall it
  if brew ls --versions "$_formula" >/dev/null; then
    echo ""
    echo "WARNING: '$_formula' already installed, do you want to uninstall it? [y/N]"
    local _reply=$(bash -c "read -n 1 -r && echo \$REPLY")
    echo ""
    if [[ $_reply =~ ^[Yy]$ ]]; then
      echo "INFO: Uninstalling '$_formula'"
      brew unpin "$_formula"
      if ! brew uninstall "$_formula"; then
        echo "ERROR: Failed to uninstall '$_formula'"
        return 1
      fi
    else
      echo "ERROR: '$_formula' is already installed, aborting"
      return 1
    fi
  fi

  # install the downloaded formula
  echo "INFO: Installing ${_formula}@${_version} from local file: $_formula_path"
  brew install --formula "$_formula_path"
  brew pin "$_formula"
}

bindkey jj vi-cmd-mode

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias cd='z'
alias cl='clear'
alias catp='bat -P'
alias cat='bat'
alias ld='eza -lD'
alias lf='eza -lF --color=always | grep -v /'
alias lh='eza -dl .* --group-directories-first'
# alias ll='eza -al --group-directories-first'
# alias ls='eza -alF --color=always --sort=size | grep -v /'
# alias lt='eza -al --sort=modified'
alias ls="eza --icons -F -H --group-directories-first --git -1"
alias ll="ls -alF"
alias lt="eza --tree --icons -a -I '.git|__pycache__|.mypy_cache|.ipynb_checkpoints'"
alias gg="lazygit"
alias n="nvim"

export LANG=en_US.UTF-8

export PATH=/opt/homebrew/bin:$PATH
export EDITOR=/opt/homebrew/bin/nvim
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# export STARSHIP_CONFIG=~/.config/starship/starship.toml

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# bun completions
[ -s "/home/mphung97/.bun/_bun" ] && source "/home/mphung97/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
