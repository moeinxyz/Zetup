# Zetup - Shared Aliases
# ======================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# List files with enhanced colors (macOS compatible)
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ll='ls -alFG'
    alias la='ls -AG'
    alias l='ls -CFG'
    alias lt='ls -altrG'
    alias lh='ls -lhG'
else
    alias ll='ls -alF --color=auto'
    alias la='ls -A --color=auto'
    alias l='ls -CF --color=auto'
    alias lt='ls -altr --color=auto'
    alias lh='ls -lh --color=auto'
fi
alias tree='tree -C'

# Git shortcuts with enhanced visuals
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
alias gd='git diff --color-words'
alias gdc='git diff --cached --color-words'
alias gf='git fetch'
alias gl='git log --oneline --graph --decorate --color=always'
alias gll='git log --graph --pretty=format:"%C(bold red)%h%Creset -%C(bold yellow)%d%Creset %s %C(bold green)(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit --color=always'
alias glll='git log --graph --pretty=format:"%C(bold magenta)*%C(bold red)%h%Creset %C(bold cyan)> %s%Creset %C(bold yellow)| %d%Creset %C(bold green)@ %cr%Creset %C(bold blue)~ %an%Creset" --abbrev-commit --color=always'
alias gp='git push'
alias gpl='git pull'
alias gr='git remote'
alias grv='git remote -v'
alias gs='git status --short --branch'
alias gss='git status -s'
alias gst='git stash'
alias gstp='git stash pop'
alias gtree='git log --graph --oneline --all --decorate --color=always'

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

# macOS specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias finder='open -a Finder'
    alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
    alias brewup='brew update && brew upgrade && brew cleanup'
    alias cask='brew install --cask'
    alias cpu='top -l 1 | grep "CPU usage"'
    alias mem='vm_stat | perl -ne "/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf(\"%-16s % 16.2f Mi\n\", \"$1:\", $2 * $size / 1048576);"'
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

# Fun and geeky commands
alias matrix='LC_ALL=C tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'
alias neo='echo -e "\033[32m"; while :; do echo $RANDOM | md5sum | cut -c 1-32 | tr "[0-9]" " " | sed "s/[a-f]/█/g"; sleep 0.1; done'
alias hacker='echo -e "\033[92m"; for i in {1..1000}; do echo -n "$(shuf -n1 -e 0 1)"; sleep 0.01; done; echo'
alias rainbow='yes "$(seq 231 -1 16)" | while read i; do printf "\x1b[48;5;${i}m\n"; sleep .02; done'
alias starwars='telnet towel.blinkenlights.nl'
alias pipes='pipes.sh -t 2'

# Load local machine-specific aliases
[[ -f "$HOME/.config/zetup/aliases.local.zsh" ]] && source "$HOME/.config/zetup/aliases.local.zsh"