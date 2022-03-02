# `bash` auto-runs this for 'interactive non-login shells', i.e. subshells started by
# typing `bash` or opening a new terminal window.

alias j="julia"
alias e="explorer ."
alias c="code ."
alias ll="ls -la"
alias cl="clear"
alias jup="jupyter notebook"
alias condini="install_conda_in_bash"  # "conda init"

# Configure bash to be able to use `conda activate {envname}` etc.
# We don't do this by default (i.e. run this here in `.bashrc`), as it's slow.
install_conda_in_bash() {
    eval "$('conda' 'shell.bash' 'hook')"
}
