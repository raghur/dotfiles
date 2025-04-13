export MAKEFLAGS="-j 18"
export MISE_ENV_FILE=.env
if command -v nvim > /dev/null ; then
    export EDITOR="$(which nvim)"
    export SUDO_EDITOR="$(which nvim)"
fi
