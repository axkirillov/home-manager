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
# rbenv
status --is-interactive; and rbenv init - fish | source

set PATH (go env GOPATH)/bin:$PATH

# just completions
source $HOME/.config/home-manager/just.fish
