# global vars
set -xg XDG_CONFIG_HOME "$HOME/.config"
set -xg EDITOR nvim
set -xg VISUAL $EDITOR
# needed for ruby integration with neovim
set -xg GEM_HOME $HOME/.gem/bin/
set -xg HOMEBREW_NO_AUTO_UPDATE 1
