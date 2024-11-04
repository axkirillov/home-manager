source $HOME/fish/globals.fish
source $HOME/fish/aliases.fish
source $HOME/fish/bindings.fish

# functions are in $HOME/fish/
for file in $HOME/fish/functions/*.fish
	source $file
end

# secret stuff
for file in $HOME/fish/secret/*.fish
	source $file
end

fish_add_path (go env GOPATH)/bin

# just completions
source $HOME/.config/home-manager/just.fish
