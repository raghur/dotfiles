
if ! command -v virsh > /dev/null; then
    return
fi
function startwinvm() {
    domain=${1:-win10}
    if virsh list --name |grep -qv $domain; then
        virsh start $domain
    fi
    virt-viewer $domain &
}
function stopwinvm() {
    domain=${1:-win10}
    if virsh list --name |grep -q $domain; then
        virsh shutdown --mode agent $domain
    fi
}

