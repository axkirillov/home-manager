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

if status is-interactive
and not set -q TMUX
    if tmux has-session -t home
	exec tmux attach-session -t home
    else
        tmux new-session -s home
    end
end

# just completions
source $HOME/.config/home-manager/just.fish
