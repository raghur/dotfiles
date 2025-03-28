function setup_kubectx() {
    if ! command -v kubectl > /dev/null; then
        return
    fi
    AGKOZAK_CUSTOM_RPROMPT+='|$(kube_ps1)'
    KUBE_PS1_NS_ENABLE=false
    KUBE_PS1_SYMBOL_ENABLE=false
    KUBE_PS1_CTX_COLOR='red'
    function get_cluster_short() {
        case $1 in
            *"sandbox"*)
                KUBE_PS1_CTX_COLOR='blue'
                echo Sandbox
                ;;
            *"dev"*)
                echo Nonprod
                ;;
            *"prod"*)
                echo Production
                ;;
            *)
                echo $1
                ;;
        esac
    }
KUBE_PS1_CLUSTER_FUNCTION=get_cluster_short

}
setup_kubectx
