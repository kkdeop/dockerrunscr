########################
# OpenVPN over Tor
# made for Tails 2.4.x
########################
#check necessary rights
if [ ! `id -u` = 0 ] ; then
  echo "This script needs to be run using 'sudo SCRIPT' or in 'root terminal'"
  echo "exiting now"
	exit
fi

#populate vars
phys_if=`ip route | grep default | awk '{print $5}'`
phys_IP=`ip route | grep kernel  | awk '{print $1}'`
phys_gw=`ip route | grep default | awk '{print $3}'`

#install openvpn
if [ ! -f /usr/sbin/openvpn ]
then
	apt-cache search openvpn 2>/dev/nul | grep "openvpn - virtual private network daemon" || apt-get update
	apt-get install -y openvpn
fi

# configure ferm.conf to allow access to 9053/tcp for user root and (re)route Tor traffic trough phys. interface
if ! cat /etc/ferm/ferm.conf | grep "outerface tun0 mod owner uid-owner clearnet"  
then
	awk '/TransPort/{print "                # White-list access to Tor socks port for OpenVPN" RS "                daddr 127.0.0.1 proto tcp dport 9053 {" RS "                    mod owner uid-owner root ACCEPT;" RS "                }" RS RS $0;next}1' /etc/ferm/ferm.conf >/tmp/ferm.conf && mv /tmp/ferm.conf /etc/ferm
	awk '/^        chain POSTROUTING/{del=2;print;print "            policy ACCEPT;" RS RS "            # SNAT Tor packets to physical interfaces IP" RS "            outerface '$phys_if' mod mark mark 42 SNAT to-source '$phys_IP';" RS "        }" RS RS "        chain OUTPUT {";next} {if(!del)print} /^        chain OUTPUT /{del=0}' /etc/ferm/ferm.conf >/tmp/ferm.conf && mv /tmp/ferm.conf /etc/ferm
	awk '/^            daddr 127.0.0.1 proto udp dport 53 REDIRECT to-ports 5353;/{del=2;print;print "        }" RS "    }" RS RS "    table mangle {" RS "        chain OUTPUT {" RS "            # mark Tor-packets for re-routing through physical interface" RS "            mod owner uid-owner debian-tor MARK set-mark 42;" RS "        }" RS "    }" RS "}" RS RS "# IPv6:" ;next} {if(!del)print} /^# IPv6/{del=0}' /etc/ferm/ferm.conf >/tmp/ferm.conf && mv /tmp/ferm.conf /etc/ferm
fi
#reload ferm
/etc/init.d/ferm reload

# add add SocksPort 9053 for OpenVPN to torrc
## SocksPort for OpenVPN
if ! cat /etc/tor/torrc | grep "SocksPort for OpenVPN"
then
	awk '/SocksPort 127.0.0.1:9150 IsolateSOCKSAuth KeepAliveIsolateSOCKSAuth/{print $0 RS "## SocksPort for OpenVPN" RS "SocksPort 127.0.0.1:9053 PreferSOCKSNoAuth";next}1' /etc/tor/torrc >/tmp/torrc && mv /tmp/torrc /etc/tor
	chown debian-tor:debian-tor /etc/tor/torrc
	chmod 644 /etc/tor/torrc
fi

## reroute Tor traffic through physical interface
if ! ip rule show | grep "fwmark 0x2a lookup 42"
then
	# Route marked packets via physical interface
	ip rule add fwmark 42 table 42
	ip route add default via $phys_gw dev $phys_if table 42
fi

#restart Tor
restart-tor

#modify OpenVPN config
cat /home/amnesia/Persistent/vpn.ovpn | grep "socks-proxy 127.0.0.1 9053" || awk '/^remote /{print $0 RS "socks-proxy 127.0.0.1 9053";next}1' /home/amnesia/Persistent/vpn.ovpn > /etc/openvpn/vpn.ovpn

#start openvpn
openvpn /etc/openvpn/vpn.ovpn &
