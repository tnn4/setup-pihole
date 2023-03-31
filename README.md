# Set up a network level ad-blocker with pi-hole

TODO:
- assign multiple ip on your interface so you don't have to mess with your original ip

Prereqs: 
- basic networking knowledge
- access to your router
- a computer that can run docker

Do you love ads? I do. I love to kill them and I'm going to show you how.

You don't need a raspberry pi to run a pi-hole.

Pi-hole is simply a linux app that acts as a network-level ad blocker which basically means its more powerful than a browser level ad-blocker since it can inspect and see bad traffic before it even reaches your computer. i.e. no ads that can get through

Since it's a linux app, you can run it anywhere you can run docker which includes Windows 10 and Windows 11, not just linux

# [Install docker if you don't have it](https://docs.docker.com/engine/install/)
Why docker? It makes installing the application much easier.

Docker packages all the dependencies that the app needs for you (containerizes the app) so you don't have to deal with hassle of installing it yourself manually which is error-prone (i.e. what if you download the wrong version of a dependency that breaks the app?)


# Download the docker image
`docker pull pihole/pihole`

If on Linux and you haven't set up a non-sudo docker user:
-`sudo docker pull pihole/pihole`

Give the computer that will be running the pi-hole a static ip

Get your ip info
windows: `ipconfig`
linux: `ifconfig`

RHEL/CentOS/Fedora


`/etc/sysconfig/network`
```
NETWORKING=yes
HOSTNAME=my_server
GATEWAY=192.168.1.1
NETWORKING_IPV6=no
IPV6INIT=no
```

`etc/sysconfig/network-scripts/ifcfg-eth0`
```
DEVICE="eth0"
BOOTPROTO="static"
DNS1="8.8.8.8" # CHANGE
DNS2="4.4.4.4" # CHANGE
GATEWAY="192.168.0.1" 
HOSTNAME="node01.tecmint.com"
HWADDR="00:19:99:A4:46:AB"
IPADDR="192.68.0.100"
NETMASK="255.255.255.0"
NM_CONTROLLED="yes"
ONBOOT="yes"
TYPE="Ethernet"
UUID="8105c095-799b-4f5a-a445-c6d7c3681f07"
```

Info on [resolve.conf](https://man7.org/linux/man-pages/man5/resolv.conf.5.html)

Edit `resolve.conf`
```
nameserver 8.8.8.8 # replace with pihole ip
nameserver 4.4.4.4 # replace with pihole ip
```

Debian/Ubuntu/PopOS

cat `etc/network/interfaces`


DNS 1.0.0.1 (Cloudflare's)
DNS 1.1.1.1 (Cloudflare's DNS)

# create a customized Docker command

Check [pihole environment variables](https://github.com/pi-hole/docker-pi-hole#environment-variables) 
for more details:

| environment variables | description |
| --- | --- |
| - ServerIP - | your pihole ip |
|- WEBPASSWORD |- password for pihole container |
|- [TZ](https://infocenter-archive.sybase.com/help/index.jsp?topic=/com.sybase.infocenter.dc38151.1270/html/iqref/BGBIJFAJ.htm) | timezone variable |
|- DNS1, DNS2, DNS3 |- ip addresses for DNS servers, use your own or use cloudflare's or google's |

example docker command run with shell script
``` sh
#!/bin/bash

PIHOLE_IP="192.168.1.112"
PIHOLE_PASSWORD="opensesame"

docker run -d --name pihole \
-e ServerIP=$PIHOLE_IP \
-e WEBPASSWORD=$PIHOLE_PASSWORD \
-e TZ=America/Chicago \
-e DNS1=127.0.0.1 DNS2=1.1.1.1 -e DNS3=1.0.0.1 \
-p 80:80 -p 53:53/tcp -p 53:53/udp -p 443:443 \
--restart=unless-stopped pihole/pihole:latest
```

Change the DNS Server on your router.

Change the  DNS ip address of your router to point to the PC that is running the pihole.