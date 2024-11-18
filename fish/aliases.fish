# aliases
alias ks="k9s"
alias k=kubectl
alias ls="lsd"
alias ssh-add-rsa="ssh-add $HOME/.ssh/id_rsa"
alias update-kitty="curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
alias v=nvim
alias vi=nvim
alias vim=nvim
alias lzd="lazydocker"
alias lg="$HOME/scripts/fzf-grep.sh"
alias add-ticket-number="~/repo/bulk-edit-git-commit-messages/begcm.sh"
alias mfa ~/repo/dev-cluster/aws/aws-mfa-check.sh
alias repo "cd $HOME/repo/(ls $HOME/repo | fzf)"
alias hx "hx -c $HOME_MANAGER/helix/config.toml"
alias v 'fg $(eval "pgrep -P $fish_pid nvim") || nvim'
alias last-run "open -u $(gh run list --limit 1 --json url --jq '.[0].url')"
alias up "docker compose up -d --build"
alias down "docker compose down"
alias awsprof "~/scripts/awsprof.sh"
alias python python3
alias aider='python -m aider'
