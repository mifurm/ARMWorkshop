#choose port to listen to
#vm01 - 137.117.195.227, 10.0.0.4
#vm02 - 40.115.0.60, 10.0.0.5
#http://jensd.be/343/linux/forward-a-tcp-port-to-another-ip-or-port-using-nat-with-iptables


sudo sysctl net.ipv4.ip_forward
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sysctl -p

#sudo systemctl start iptable
#lsmod|grep iptable

sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 10.0.0.5:80
sudo iptables -t nat -A POSTROUTING -p tcp -d 10.0.0.5 --dport 80 -j SNAT --to-source 10.0.0.4
sudo iptables -t nat -L -n

sudo iptables-save | sudo tee /etc/iptables.up.rules
