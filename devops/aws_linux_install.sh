#!/usr/bin/env bash

# Must be run as root, or with `sudo`.

set -e

# Docker
yum install docker \
            git
service docker start
usermod -a -G docker ec2-user
chkconfig docker on

# Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
PATH=$PATH:/usr/local/bin

# CVAT
git clone https://github.com/ic/cvat
pushd cvat
git checkout develop # TODO, specify the commit/tag.
docker-compose build
docker-compose up -d
docker exec -it cvat bash -ic 'python3 ~/manage.py createsuperuser'

echo "Good to go on this server at port 8080"
