FROM docker.io/library/ubuntu:24.04

LABEL maintainer="Chris Mason <chris@netnix.org>"

ARG DEBIAN_FRONTEND="noninteractive"

ADD --chmod=644 https://dl.ui.com/unifi/unifi-repo.gpg /usr/share/keyrings/unifi-repo.gpg

RUN set -eux; \

groupadd -g 99 -r unifi; \
useradd -u 99 -g 99 -r -l unifi; \

apt-get update; \
apt-get install -y --no-install-recommends gnupg curl ca-certificates; \

curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | gpg -o /usr/share/keyrings/mongodb-repo.gpg --dearmour; \

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/unifi-repo.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti" >/etc/apt/sources.list.d/100-ubnt-unifi.list; \
echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-repo.gpg] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" >/etc/apt/sources.list.d/100-mongodb-org.list; \

apt-get update; \
apt-get install -y --no-install-recommends mongodb-org; \
apt-get install -y --no-install-recommends unifi; \

apt-get clean; \
apt-get autoclean; \

rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*; \

chown -R unifi:unifi /usr/lib/unifi; \
chown -R unifi:unifi /var/lib/unifi; \
chown -R unifi:unifi /var/log/unifi; \
chown -R unifi:unifi /var/run/unifi

USER 99:99

WORKDIR /usr/lib/unifi

ADD --chmod=755 https://raw.githubusercontent.com/cmason3/unifi/main/entrypoint.sh /usr/lib/unifi/bin/entrypoint.sh

HEALTHCHECK --start-period=5m CMD curl --max-time 5 -kILs --fail https://localhost:8443 || exit 1

ENTRYPOINT [ "/usr/lib/unifi/bin/entrypoint.sh" ]
