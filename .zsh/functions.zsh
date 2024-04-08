# Colormap
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

# Kubernetes
reloadK8s() {
    trap 'trap - ERR; return' ERR
    silent="false"
    while [ $# -gt 0 ]; do
        case "$1" in
            -s|--silent) silent="true" ;;
            -h|--help) echo "Usage: kube-reload [-s|--silent]"; return 0 ;;
            *) echo "Invalid option: $1"; echo "Usage: kube-reload [-s|--silent]"; return 1 ;;
        esac
        shift
    done
    [ "${silent}" = "false" ] && { echo "Reloading kubeconfigs . . ."; }
    if test -d ~/.kube; then
        export KUBECONFIG=""
        KUBECONFIG_REAL=~/.kube/config
        touch "${KUBECONFIG_REAL}"
        custom_contexts_dir=~/.kube/custom-contexts
        mkdir -p ~/.kube/custom-contexts
        custom_contexts_dir="$(cd "${custom_contexts_dir}" && pwd)"
        [ "${silent}" = "false" ] && { echo "Custom Contexts Directory: '${custom_contexts_dir}'"; }
        for file in $(find ~/.kube/custom-contexts/ -name '*.conf' \( -type f -o -type l \)); do
            [ "${silent}" = "false" ] && { printf "\t${file}\n" | sed -E "s|${custom_contexts_dir}|\.|"; }
            file="$(echo "${file}" | sed "s/\/\//\//")" # replace double slashes to single
            export KUBECONFIG="${KUBECONFIG}:${file}"
        done
        if [ "${KUBECONFIG}" = "" ]; then
            [ "${silent}" = "false" ] && { echo "No custom kubeconfigs found"; }
        else
            kubectl config view --raw >"${KUBECONFIG_REAL}"
            [ "${silent}" = "false" ] && { echo "All contexts successfully joined into '${KUBECONFIG_REAL}'"; }
        fi
        export KUBECONFIG="${KUBECONFIG_REAL}"
    fi
    return 0
}
