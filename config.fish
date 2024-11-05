set -xg HOME_MANAGER "$HOME/repo/home-manager"
source $HOME_MANAGER/fish/globals.fish
source $HOME_MANAGER/fish/aliases.fish
source $HOME_MANAGER/fish/bindings.fish
source $HOME_MANAGER/fish/secret.fish

# functions are in $HOME/fish/
for file in $HOME_MANAGER/fish/functions/*.fish
	source $file
end

fish_add_path (go env GOPATH)/bin
fish_add_path /Library/Frameworks/Python.framework/Versions/3.12/bin

# just completions
source $HOME_MANAGER/fish/completions/just.fish
