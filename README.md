# UniFi Network Controller

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
sudo podman build --no-cache --pull -t unifi:latest --format docker \
  https://raw.githubusercontent.com/cmason3/unifi/main/Dockerfile

sudo podman create --name unifi --tz=local --network host \
  -v /var/lib/unifi:/var/lib/unifi:Z \
  -v /var/log/unifi:/var/log/unifi:Z \
  unifi:latest

sudo podman generate systemd -n --restart-policy=always unifi \
  | sudo tee /etc/systemd/system/unifi.service 1>/dev/null

sudo systemctl daemon-reload
sudo systemctl enable --now unifi
```
