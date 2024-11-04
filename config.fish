set -xg HOME_MANAGER "$HOME/repo/home-manager"
source $HOME_MANAGER/fish/globals.fish
source $HOME_MANAGER/fish/aliases.fish
source $HOME_MANAGER/fish/bindings.fish

# functions are in $HOME/fish/
for file in $HOME_MANAGER/fish/functions/*.fish
	source $file
end

# secret stuff
for file in $HOME_MANAGER/fish/secret/*.fish
	source $file
end

fish_add_path (go env GOPATH)/bin

# just completions
source $HOME_MANAGER/fish/completions/just.fish
