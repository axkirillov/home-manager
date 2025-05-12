set -xg HOME_MANAGER "$HOME/repo/home-manager"
source $HOME_MANAGER/fish/globals.fish
source $HOME_MANAGER/fish/aliases.fish
source $HOME_MANAGER/fish/secret.fish

for file in $HOME_MANAGER/fish/functions/*.fish
	source $file
end

for file in $HOME_MANAGER/fish/completions/*.fish
  source $file
end

fish_add_path (go env GOPATH)/bin
