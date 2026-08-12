# Stop here for non-interactive shells.
[[ $- != *i* ]] && return

# Paths
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/miniconda3/bin:$HOME/bin:$PATH"
export PATH="$PATH:$HOME/.lmstudio/bin"
export EIGEN_INCLUDE_PATH=/usr/include/eigen3
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Keep useful history across every open terminal.
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=50000
HISTFILESIZE=100000
shopt -s histappend checkwinsize cmdhist

# Modern command-line tools already installed on this machine.
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons=auto --group-directories-first'
    alias ll='eza -lah --icons=auto --group-directories-first --git'
    alias tree='eza --tree --icons=auto --group-directories-first'
else
    alias ls='ls --color=auto'
    alias ll='ls -lah --color=auto'
fi

alias grep='grep --color=auto'
alias preview='bat --style=numbers,changes --color=always'
alias c='clear'

if [[ -r /usr/share/fzf/completion.bash ]]; then
    source /usr/share/fzf/completion.bash
fi

if [[ -r /usr/share/fzf/key-bindings.bash ]]; then
    source /usr/share/fzf/key-bindings.bash
fi

function vctl() {
    echo "volumectl set ${1}%"
    volumectl set "${1}%"
}

function bt() {
    bluetoothctl connect 'AC:3E:B1:84:40:5D'
}

function whichPackage() {
    local executable
    executable="$(command -v "${1}")" || return
    yay -Qo "$executable"
}

function datetime() {
    date +%s
}

function findBin() {
    local needle=${1:?"usage: findBin NAME"}
    local directory

    while IFS= read -r directory; do
        [[ -d "$directory" ]] || continue
        find "$directory" -maxdepth 1 -type f -iname "*$needle*" 2>/dev/null
    done < <(tr ':' '\n' <<< "$PATH")
}

function findText() {
    rg --hidden --glob '!.git' -- "$1" "${2:-.}"
}

function findFile() {
    fd --hidden --exclude .git -- "$1" "${2:-.}"
}

git_branch() {
    git symbolic-ref --quiet --short HEAD 2>/dev/null \
        || git rev-parse --short HEAD 2>/dev/null
}

prompt_command() {
    local exit_code=$?
    local blue='\[\e[38;2;137;180;250m\]'
    local green='\[\e[38;2;166;227;161m\]'
    local mauve='\[\e[38;2;203;166;247m\]'
    local red='\[\e[38;2;243;139;168m\]'
    local subtext='\[\e[38;2;166;173;200m\]'
    local reset='\[\e[0m\]'
    local branch=""
    local environment=""
    local status=""
    local symbol="${mauve}❯${reset}"

    history -a
    history -n
    branch="$(git_branch)"

    if [[ -n "$VIRTUAL_ENV" ]]; then
        environment="$(basename "$VIRTUAL_ENV")"
    fi

    if (( exit_code != 0 )); then
        status="${red}✘ ${exit_code}${reset}  "
        symbol="${red}❯${reset}"
    fi

    PS1="${blue}  \w${reset}"
    [[ -n "$branch" ]] && PS1+="  ${green} ${branch}${reset}"
    [[ -n "$environment" ]] && PS1+="  ${mauve}󰌠 ${environment}${reset}"
    PS1+="\n${status}${subtext}╰─${reset}${symbol} "
}

PROMPT_COMMAND=prompt_command
