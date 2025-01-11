#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PROMPT_COMMAND='start_time=$(date +%s%3N)'

# export PATH="/opt/anaconda/bin:$PATH"  # commented out by conda initialize

calculate_execution_time() {
	end_time=$(date +%s%3N)
	execution_time=$((end_time - start_time))
	echo "[$execution_time ms]"
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\W $(calculate_execution_time)]\$' 
export EIGEN_INCLUDE_PATH=/usr/include/eigen3

function vctl () {
    echo "volumectl set ${1}%"
    volumectl set "${1}"%
}

function bt () {
    bluetoothctl connect 'AC:3E:B1:84:40:5D'
}

function whichPackage () {
    yay -Qo "$(which "${1}")"
}

function datetime() {
    date +%s
}

# TODO: isolate only files with this string in file name, not path
function findBin() {
    dirs=$(echo "$PATH" | tr ":" "\n")
    for d in $dirs; do
        find "$d" -type f | grep --color "$1"
    done
}

findText ()
{
    grep --color=auto -E -irn "$1"
}

function findFile() {
    find . 2>/dev/null -name *"$1"*
}

# TODO:replaceText (same as above, but with replace option)
# $1 - text to search
# $2 - text to replace
# $3 - (optional) 

#function condaStart() {
#    echo "[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc
#}
#
## >>> conda initialize >>>
## !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/opt/anaconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/opt/anaconda/etc/profile.d/conda.sh" ]; then
#        . "/opt/anaconda/etc/profile.d/conda.sh"
#    else
#        export PATH="/opt/anaconda/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<
#
