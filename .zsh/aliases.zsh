alias k="kubectl"
alias h="helm"
alias tf="terraform"
alias kubectx='f() { kubectl config get-contexts -o name | fzf --height=30 | xargs kubectl config use-context ; } ; f'
alias kubens='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'