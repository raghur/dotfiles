[[ $(uname -a) == *"WSL2"* ]] || return
# echo $USER
# echo "setting mtu"
#   sudo visudo /etc/sudoers.d/ip
#   myuser ALL=NOPASSWD: /usr/sbin/ip
sudo /usr/sbin/ip link set eth0 mtu 1400
# for running X Gui apps
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
