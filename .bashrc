# `bash` auto-runs this for 'interactive non-login shells', i.e. subshells started by
# typing `bash` or opening a new terminal window.

alias j="julia --sysimage=$HOME/phd/sysimg/mysys.dll"
alias jf="julia"
alias e="explorer ."
alias c="code ."
alias ll="ls -la"
alias cl="clear"
alias jup="jupyter notebook"
alias ip="ipython"
alias condinit="configure_bash_for_conda"

# Configure bash to be able to use `conda activate {envname}` etc.
# We don't do this by default (i.e. run this here in `.bashrc`), as it's slow.
# (maybe `mamba init` is faster?)
configure_bash_for_conda() {
    eval "$('conda' 'shell.bash' 'hook')"
}
