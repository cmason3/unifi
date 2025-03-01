<h1 align="center">UniFi Network Controller</h1>
<h2 align="center">Raspberry Pi 5 and Podman</h2>

```
sudo groupadd -g 99 -r unifi
sudo useradd -u 99 -g 99 -r -l unifi
```

```
sudo mkdir -p /var/lib/unifi
sudo chown -R unifi:unifi /var/lib/unifi

sudo mkdir -p /var/log/unifi
sudo chown -R unifi:unifi /var/log/unifi
```

```
sudo podman system prune -a -f

sudo podman build --no-cache --pull -t unifi:latest --format docker \
  -f https://raw.githubusercontent.com/cmason3/unifi/main/Dockerfile

sudo podman create --name unifi --tz=local --network host \
  -v /var/lib/unifi:/var/lib/unifi:Z \
  -v /var/log/unifi:/var/log/unifi:Z \
  unifi:latest

sudo podman generate systemd -n --restart-policy=always unifi \
  | sudo tee /etc/systemd/system/unifi.service 1>/dev/null

sudo systemctl daemon-reload
sudo systemctl enable --now unifi
```

If you want to use a Let's Encrypt TLS Certificate for your UniFi Network Controller then you can use the following commands to import the certificate into UniFi, although you will need to remember to renew it every 90 days (you can put this into a script and call it from the certbot cronjob using "--deploy-hook /etc/certbot-renew.sh"):

```
sudo openssl pkcs12 -export -in "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" -inkey "/etc/letsencrypt/live/${DOMAIN}/privkey.pem" \
  -out "/var/lib/unifi/pkcs12.tmp" -passout pass:"aircontrolenterprise" -name "unifi"

sudo chown unifi:unifi /var/lib/unifi/pkcs12.tmp

sudo cp /var/lib/unifi/keystore /var/lib/unifi/keystore.bak

sudo podman exec -it unifi keytool -delete -alias "unifi" -keystore "/var/lib/unifi/keystore" -deststorepass "aircontrolenterprise"

sudo podman exec -it unifi keytool -importkeystore -srckeystore "/var/lib/unifi/pkcs12.tmp" -srcstoretype PKCS12 -srcstorepass "aircontrolenterprise" \
  -destkeystore "/var/lib/unifi/keystore" -deststorepass "aircontrolenterprise" -destkeypass "aircontrolenterprise" -alias "unifi" -trustcacerts

sudo systemctl restart unifi
```
