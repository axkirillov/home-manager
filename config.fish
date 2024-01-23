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

# initializations go at the end:
# prompt 
starship init fish | source
# rbenv
status --is-interactive; and rbenv init - fish | source

set PATH (go env GOPATH)/bin:$PATH

# Generated for envman. Do not edit.
test -s "$HOME/.config/envman/load.fish"; and source "$HOME/.config/envman/load.fish"

# just completions
source $HOME/.config/home-manager/just.fish
