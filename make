#!/bin/bash
apt-get update
apt-get upgrade
wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubiBackup/doubi/master/ssr.sh && chmod +x ssr.sh && bash ssr.sh
bash <(curl -s -L https://git.io/v2ray.sh)
apt-get install ffmpeg
wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl
wget --no-check-certificate https://raw.githubusercontent.com/EequMCC/some-script/master/yc
chmod +x yc && mv yc /usr/bin
echo "export LC_ALL=en_US.UTF-8">>/etc/profile
source /etc/profile
chattr -i /etc/udev/rules.d/70-persistent-net.rules
rm /etc/udev/rules.d/*
echo "auto ens3" >>/etc/network/interfaces
/etc/init.d/networking restart