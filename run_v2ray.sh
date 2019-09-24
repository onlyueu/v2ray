bash <(curl -L -s https://install.direct/go.sh)
mv /etc/v2ray/config.json /etc/v2ray/config.json.bk
port="$(grep 'port' /etc/v2ray/config.json.bk)"
id="$(grep 'id' /etc/v2ray/config.json.bk)"
oport="$(echo '"port": 11111,')"
oid="$(echo '"id": "2a6af611-1111-4da3-b446-8866e398031a",')"

cat >/etc/v2ray/config.json <<EOL
    {
        "log": {
                "access": "/var/log/v2ray/access.log",
                "error": "/var/log/v2ray/error.log",
                "loglevel": "warning"
        },
        "inbound": {
                "port": 11111,
                "protocol": "vmess",
                "settings": {
                        "clients": [{
                                "id": "2a6af611-1111-4da3-b446-8866e398031a",
                                "level": 1,
                                "alterId": 64,
                                "security": "auto"
                        }]
                },
                "streamSettings":{
                        "network":"ws",
                        "security": "auto",
                        "wsSettings":{
                                "path": "/enterv2ray/"
                                }
                        }
        },
        "outbound": {
                "protocol": "freedom",
                "settings": {}
        },
        "outboundDetour": [
            {
                "protocol": "blackhole",
                "settings": {},
                "tag": "blocked"
            }
        ],
        "routing": {
            "strategy": "rules",
            "settings": {
                "rules": [
                    {
                        "type": "field",
                        "ip": [
                            "0.0.0.0/8",
                            "10.0.0.0/8",
                            "100.64.0.0/10",
                            "127.0.0.0/8",
                            "169.254.0.0/16",
                            "172.16.0.0/12",
                            "192.0.0.0/24",
                            "192.0.2.0/24",
                            "192.168.0.0/16",
                            "198.18.0.0/15",
                            "198.51.100.0/24",
                            "203.0.113.0/24",
                            "::1/128",
                            "fc00::/7",
                            "fe80::/10"
                        ],
                        "outboundTag": "blocked"
                    }
                ]
            }
        }
    }
EOL

sed -i -e "s/$oport/$port/" -e "s/$oid/$id/" /etc/v2ray/config.json

while true; do
    read -p "Do you want to get a QR code for v2ray? (y or n)" ans
    case $ans in
        [Yy]* ) apt-get install qrencode -y; id="$(grep 'id' /etc/v2ray/config.json)"; qrencode -t ASCIIi $(echo $id| cut -d'"' -f 4);echo $id| cut -d'"' -f 4; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
    esac
done

