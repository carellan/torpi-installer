apt-get install hostapd dnsmasq -y
systemctl stop hostapd
systemctl stop dnsmasq


cat <<EOF >> /etc/dhcpcd.conf #Falta if
interface wlan0
static ip_address=192.168.220.1/24
    nohook wpa_supplicant
EOF

systemctl restart dhcpcd


cat <<EOF > /etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
hw_mode=g
channel=6
ieee80211n=1
wmm_enabled=0
macaddr_acl=0
ignore_broadcast_ssid=0
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
# Este es el nombre de la SSID
ssid=TorPi
# Este es el password de la SSID
wpa_passphrase=TorPi2020
EOF


cat <<EOF >> /etc/default/hostapd
DAEMON_CONF="/etc/hostapd/hostapd.conf"
EOF







sed -i 's/#DAEMON_CONF=\/etc\/hostapd\/hostapd.conf//' /etc/init.d/hostapd 
sed -i 's/#DAEMON_CONF=//' /etc/init.d/hostapd

sed -i 's/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf//' /etc/init.d/hostapd 
sed -i 's/DAEMON_CONF=//' /etc/init.d/hostapd 

echo DAEMON_CONF=/etc/hostapd/hostapd.conf >> /etc/init.d/hostapd 





mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig


cat <<EOF >> /etc/dnsmasq.conf
interface=wlan0
server=1.1.1.1
dhcp-range=192.168.220.50,192.168.220.150,12h
EOF


sed -i 's/net.ipv4.ip_forward=1//'
cat <<EOF >> /etc/sysctl.conf
net.ipv4.ip_forward=1
EOF

sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sh -c "iptables-save > /etc/iptables.ipv4.nat"


sed -i 's/iptables-restore < /etc/iptables.ipv4.nat //'
sed -i -e '$i \iptables-restore < \/etc\/iptables.ipv4.nat \n' /etc/rc.local


systemctl unmask hostapd
systemctl enable hostapd
systemctl start hostapd
service dnsmasq start


