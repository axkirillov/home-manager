# Ensure writable temp dirs early (fix mktemp/.psub permission issues)
if not set -q TMPDIR; or string match -q "/var/folders/zz/*" -- $TMPDIR
    set -l d (getconf DARWIN_USER_TEMP_DIR 2>/dev/null; or echo /tmp/)
    set -xg TMPDIR $d
end
# Ensure zsh process substitution and helpers use a safe prefix
set -xg TMPPREFIX "$TMPDIR"zsh/
mkdir -p "$TMPPREFIX"
chmod 700 "$TMPPREFIX" 2>/dev/null

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
