#!/bin/sh
# source: https://github.com/kiasaki/docker-alpine-elasticsearch/

# match version on live hosting
export VERSION="5.2.2"
export GOSU="1.7"

apk update
apk add curl openjdk8-jre
curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/${GOSU}/gosu-amd64"
chmod +x /usr/local/bin/gosu &&
curl -o elasticsearch-${VERSION}.tar.gz -sSL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VERSION}.tar.gz
tar -xzf elasticsearch-${VERSION}.tar.gz
rm elasticsearch-${VERSION}.tar.gz
mv elasticsearch-${VERSION} /usr/share/elasticsearch
mkdir -p /usr/share/elasticsearch/data /usr/share/elasticsearch/logs /usr/share/elasticsearch/config/scripts
adduser -DH -s /sbin/nologin elasticsearch
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch
apk del curl
rm -rf /var/cache/apk/*
