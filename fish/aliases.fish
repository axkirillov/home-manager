# aliases
alias ks="k9s"
alias k=kubectl
alias ls="lsd"
alias ssh-add-rsa="ssh-add $HOME/.ssh/id_rsa"
alias vi=nvim
alias vim=nvim
alias add-ticket-number="~/repo/bulk-edit-git-commit-messages/begcm.sh"
alias mfa ~/repo/dev-cluster/aws/aws-mfa-check.sh
alias repo "cd $HOME/repo/(ls $HOME/repo | fzf)"
alias v 'fg $(eval "pgrep -P $fish_pid nvim") || nvim'
alias up "docker compose up -d --build"
alias down "docker compose down"
alias jira "$HOME_MANAGER/scripts/jira.sh"
alias fzf-pod-shell "$HOME_MANAGER/scripts/fzf-pod-shell.sh"
alias aigrep "$HOME_MANAGER/scripts/aigrep.sh"
alias pr "$HOME_MANAGER/scripts/pr.sh"
alias commit "$HOME_MANAGER/scripts/commit-msg.sh"
