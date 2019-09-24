apt-get update
apt-get install curl nano -y
curl https://getcaddy.com | bash -s personal http.forwardproxy
mkdir /etc/caddy
chown -R root:www-data /etc/caddy
mkdir /etc/caddy/conf
echo 'import ./conf/*' >> /etc/caddy/Caddyfile
mkdir /etc/ssl/caddy
chown -R www-data:root /etc/ssl/caddy
chmod 0770 /etc/ssl/caddy
mkdir /var/www
chown www-data:www-data /var/www

curl -s https://raw.githubusercontent.com/mholt/caddy/master/dist/init/linux-systemd/caddy.service -o /etc/systemd/system/caddy.service
sed -i -e "s/User\=www\-data/User\=root/" /etc/systemd/system/caddy.service

echo Please input the hostname 
read hostname
echo Please input the Email address 
read email
port="$(grep 'port' /etc/v2ray/config.json)"

cat >/etc/caddy/Caddyfile <<EOL

https://$hostname {
gzip
tls $email
proxy /enterv2ray/ 127.0.0.1:$port {
    websocket
    header_upstream -Origin
  }
}
EOL
mkdir /var/www/$hostname

systemctl daemon-reload
systemctl enable caddy
systemctl start caddy
