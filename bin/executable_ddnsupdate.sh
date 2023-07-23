#! /bin/bash
external_ip=$(wget -qO- 'http://myip.dnsdynamic.org/')
wget  -qO- --no-check-certificate "https://www.dnsdynamic.org/api/?hostname=homepc.ssh01.com&myip=$external_ip"  --user "raghu.rajagopalan@gmail.com" --password view2kil1!


