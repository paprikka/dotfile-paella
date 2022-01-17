
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

# Easily switch between Node versions
# Source: https://github.com/nvm-sh/nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Load direnv
# Setup instructions: https://direnv.net/docs/hook.html

eval "$(direnv hook zsh)"



# Aliases and functions
# =====================

alias work='cd ~/Developer'
# Prevent my mac from going to sleep
# The command is called `nyan` because in the past I used 
# this: https://www.youtube.com/watch?v=SkgTxQm9DWM
alias nyan="echo '...zzZzz...' && caffeinate -d -i -s -u"

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

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

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
