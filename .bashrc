# `bash` auto-runs this for 'interactive non-login shells', i.e. subshells started by
# typing `bash` or opening a new terminal window.

alias j="julia"
alias js="julia --sysimage=$HOME/phd/sysimg/mysys.dll"
alias jn="julia --startup-file=no"
alias e="explorer ."
alias c="code ."
alias ll="ls -la"
alias cl="clear"
alias jup="jupyter lab --allow-root"
alias ip="ipython"
alias condinit="configure_bash_for_conda"

export JULIA_NUM_THREADS=7

# Configure bash to be able to use `conda activate {envname}` etc.
# We don't do this by default (i.e. run this here in `.bashrc`), as it's slow.
# (maybe `mamba init` is faster?)
configure_bash_for_conda() {
    eval "$('conda' 'shell.bash' 'hook')"
}

# From https://unix.stackexchange.com/questions/125385/combined-mkdir-and-cd
# -p: for if mkdirc'ing /with/parents
# -P: resolve symbolic links (when useful?)
# "$1": protect the argument when spaces
# --: so you can make a directory starting with `-` or `--`
mkcdir () {
    mkdir -p -- "$1" &&
       cd -P -- "$1"
}
alias mkdirc="mkcdir"

# opam configuration (OCaml)
# test -r /root/.opam/opam-init/init.sh && \
#   . /root/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/root/mambaforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/root/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/root/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/root/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
