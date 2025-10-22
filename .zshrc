export PATH=/opt/homebrew/bin:$PATH
export PATH=$HOME/bin:$PATH

# Enable the Typewritten prompt
# Source: https://typewritten.dev/#/
# The line below is required if you're using oh-my-zsh
ZSH_THEME=""
# TYPEWRITTEN_SYMBOL="λ" # not a Greek letter, but a hand holding a crowbar
# fpath+=$HOME/.zsh/typewritten
# autoload -U promptinit; promptinit
# prompt typewritten

# Install from https://starship.rs
eval "$(starship init zsh)"



# Autoload SSH keys and make passphrases easier to use
# Why you need it: https://unix.stackexchange.com/a/72558
eval "$(ssh-agent -s)" 1> /dev/null
#    echo only errors ⤴

# Load direnv
# Setup instructions: https://direnv.net/docs/hook.html

eval "$(direnv hook zsh)"

# Manage python versions

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi


# Aliases and functions
# =====================

alias work='cd ~/Developer'
alias n='nvim .'
alias prs='gh pr list --author="@me"'
alias gc='git commit'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gco='git checkout'
alias gss='git status -s'
alias ga='git add'

# Commit work quickly before cleaning up and squashing
function wip() {
  git commit --no-verify -m "wip: $* [skip ci]"
}

function yolo() {
  echo "🐐"
  ga . && wip $*
}
# Prevent my mac from going to sleep
# The command is called `nyan` because in the past I used 
# this: https://www.youtube.com/watch?v=SkgTxQm9DWM
alias nyan="echo '...zzZzz...' && caffeinate -d -i -s -u"

function markdown() {
  pandoc $1 | lynx -stdin
}

# Expose my local server to the internet and enable HTTPS
# Source: 
function serve-https() {
   ngrok http -subdomain $1 -region eu $2 
}

# Copy the current dir to the clipboard
alias pwdd="pwd | pbcopy"
alias gs="git status"
alias gl="git log"
# Show all yesterday's commits--I use it as a quick reminder of my progress
# if I'm still half-asleep during the standup:
alias gly="git log --since=yesterday.0:00am --oneline --decorate"

# From: https://github.com/Peltoche/lsd

alias ls='eza -l --icons'
alias l='eza --icons -x'
alias la='eza -a --icons'
alias lla='eza -la --icons'
alias lt='eza --tree --icons'

# Generate AppStore previews with correct sizes and metadata.
# 1. Record your device using QuickTime 
# (File->New Movie Recording->Select your phone)
# 2. Run `$ app-preview your-recording.mov`
# Required deps:
# - https://ffmpeg.org (`brew install ffmpeg`)
function app-preview() {
  echo "name $1"
  ffmpeg -i $1 -vf scale=1080:1920,setsar=1 -c:a copy "out_$1"
}

function gs-inline(){
    git status --short |
    awk '{print $2}'   | 
    awk '/START/{if (NR!=1)print "";next}{printf "%s ",$0}END{print "";}'
}

# Get all dir sizes recursively
# I use this mostly for clean-ups/managing my archive
function get-dir-sizes() {
  sudo du -H -h -d 1 | sort -hr # && say 'Meow, that took a while, friend.'
}

function mkdirp(){
  mkdir $1
  cd $1
}

function lss() {
  clear
  ls
}

# Toggle desktop icons on Mac
# Source: https://news.ycombinator.com/item?id=36496711
function  toggledesktop () {
    if [[ $(defaults read com.apple.finder CreateDesktop) -eq "0" ]]
    then
        export SHOWDESKTOP=1;
        echo "Unhiding Desktop icons"
    else
        export SHOWDESKTOP=0;
        echo "Hiding Desktop icons"
    fi
    defaults write com.apple.finder CreateDesktop $SHOWDESKTOP
    killall Finder
  }


function git_changed() {
  local base="${1:-origin/dev}"
  git diff --name-only $(git merge-base HEAD $base) HEAD | tr '\n' ' '
}

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

alias gsw='git switch $(git for-each-ref --sort=-committerdate --format="%(refname:short)" refs/heads/ | fzf)'
alias gsw-='git switch -'

alias ghostty-config='nvim ~/Library/Application\ Support/com.mitchellh.ghostty/config'

. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"
