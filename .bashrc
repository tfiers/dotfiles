# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Commands that came with the default .bashrc on WSL Ubuntu.
. ~/.bashrc_init

. ~/.bash_aliases
. ~/.bash_envvars
. ~/.bashrc_secrets/.bashrc_secrets

cp -r ~/.bashrc_secrets/.ssh ~
chown -R $USER ~/.ssh
chmod -R 600 ~/.ssh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/conda/etc/profile.d/conda.sh" ]; then
        . "/conda/etc/profile.d/conda.sh"
    else
        export PATH="/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
