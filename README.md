Following assumes setup:

```
client01 \
client02 - switch - (enp0s25):laptop:(wlp3s0) ~ network with internet
client03 /
```

Make sure packet forwarding is enabled, likely will be if you run docker locally

```
sysctl -a | grep forward
```

Set up masquerade rules to nat traffic between wlp3s0 (wifi with internet) and enp0s25 (local network with pxe clients)

```
sudo iptables -t nat -A POSTROUTING -o wlp3s0 -j MASQUERADE
sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i enp0s25  -o wlp3s0 -j ACCEPT
```

bring up interface, create a subnet and give yourself the first address
```
sudo ip link set up dev enp0s25
sudo ip addr add 192.168.1.1/24 dev enp0s25 # arbitrary address
```

MAC addresses for machines:

```
dell-01: f8:b1:56:9b:1b:6a
```
