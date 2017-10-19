# Simple, monolithical container with all dependencies for CI of the landmatrix
FROM python:3.5-alpine

# Postgis
ENV LANG en_US.utf8
ENV PGDATA /data
ENV PGPASS postgres

# Elasticsearch
ENV PATH /usr/share/elasticsearch/bin:$PATH
WORKDIR /usr/share/elasticsearch
VOLUME /usr/share/elasticsearch/data

# Use python3.5 by default
RUN ln -s -f /usr/bin/python3.5 /usr/bin/python

# Postgis
RUN mkdir /data
COPY postgis/install.sh .
RUN sh install.sh
COPY postgis/start_postgis /sbin/

# Elasticsearch
RUN mkdir -p ./config
COPY elasticsearch/config ./config
COPY elasticsearch/install.sh .
RUN sh install.sh
COPY elasticsearch/start_elasticsearch /sbin/

# Dependencies for project and functional tests
COPY landmatrix/install.sh .
RUN sh install.sh

CMD ["start_postgis", "start_elasticsearch"]
