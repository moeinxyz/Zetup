# Zetup - Shared Aliases
# ======================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# List files
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -altr'
alias lh='ls -lh'

# Git shortcuts
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gdc='git diff --cached'
alias gf='git fetch'
alias gl='git log --oneline --graph --decorate'
alias gll='git log --graph --pretty=format:"%C(yellow)%h%Creset -%C(red)%d%Creset %s %C(green)(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gp='git push'
alias gpl='git pull'
alias gr='git remote'
alias grv='git remote -v'
alias gs='git status'
alias gss='git status -s'
alias gst='git stash'
alias gstp='git stash pop'

# Docker
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias drm='docker rm'
alias drmi='docker rmi'
alias dex='docker exec -it'

# Kubernetes
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'
alias klf='kubectl logs -f'

# Network
alias myip='curl -s https://ipinfo.io/ip'
alias localip='ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2'
alias ping='ping -c 5'
alias ports='netstat -tulanp'

# System
alias h='history'
alias j='jobs -l'
alias df='df -h'
alias du='du -h'
alias free='top -l 1 -s 0 | grep PhysMem'
alias ps='ps aux'
alias path='echo -e ${PATH//:/\\n}'

# Tmux
alias tm='tmux'
alias tma='tmux attach'
alias tmk='tmux kill-session'
alias tml='tmux list-sessions'
alias tmn='tmux new-session'

# File operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -pv'
alias which='type -a'

# Archives
alias tar='tar -v'
alias untar='tar -xvf'
alias gz='tar -czf'
alias ungz='tar -xzf'

# Text processing
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias less='less -R'

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
    alias finder='open -a Finder'
    alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
    alias brewup='brew update && brew upgrade && brew cleanup'
    alias cask='brew install --cask'
else
    alias ls='ls --color=auto'
fi

# Development
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias jsonfmt='python3 -m json.tool'

# Node.js
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nw='npm run watch'
alias nc='npm run clean'

# Yarn
alias y='yarn'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn run'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'
alias yw='yarn watch'

# Quick edits
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias tmuxconf='${EDITOR:-vim} ~/.tmux.conf'
alias aliases='${EDITOR:-vim} ~/.config/zetup/aliases.zsh'
alias vimrc='${EDITOR:-vim} ~/.vimrc'

# Utilities
alias weather='curl wttr.in'
alias clock='while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done &'
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'
alias stopwatch='date; read; date'

# Fun
alias matrix='LC_ALL=C tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'

# Load local machine-specific aliases
[[ -f "$HOME/.config/zetup/aliases.local.zsh" ]] && source "$HOME/.config/zetup/aliases.local.zsh"