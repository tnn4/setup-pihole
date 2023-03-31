#!/bin/bash

PIHOLE_IP="192.168.1.112"
PIHOLE_PASSWORD="opensesame"
CLOUDFLARE_DNS_1="1.1.1.1"
CLOUDFLARE_DNS_2="1.0.0.1"
MY_TZ="America/Chicago"

docker run -d --name pihole \
-e ServerIP=$PIHOLE_IP \
-e WEBPASSWORD=$PIHOLE_PASSWORD \
-e TZ=America/Chicago \
-e DNS1=127.0.0.1 DNS2=1.1.1.1 -e DNS3=1.0.0.1 \
-p 80:80 -p 53:53/tcp -p 53:53/udp -p 443:443 \
--restart=unless-stopped pihole/pihole:latest
