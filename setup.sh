#!/bin/bash

# Salir si un comando falla
set -e

# Actualizar repositorios
apt-get update -y

# Instalar Docker y Docker Compose si no existen
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do 
  sudo apt-get remove -y $pkg || true
done

apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg 
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker

groupadd docker || true
usermod -aG docker $SUDO_USER

# Instalar auditd y Filebeat
apt install -y auditd
systemctl enable --now auditd

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --yes --dearmor -o /usr/share/keyrings/elastic-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list > /dev/null

apt-get update -y
apt-get install -y filebeat

# Respaldar la conf original
if [ -f /etc/filebeat/filebeat.yml ]; then
	mv /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.bak
fi

# Copiar el archivo de la conf personalizada
cp ./configs/filebeat.yml /etc/filebeat/filebeat.yml
chmod 600 /etc/filebeat/filebeat.yml
chown root:root /etc/filebeat/filebeat.yml

filebeat modules enable auditd system
systemctl enable filebeat
systemctl restart filebeat

echo "actualizar tu sesión actual ejecutando este comando ahora:"
echo ""
echo "    newgrp docker"
echo ""
