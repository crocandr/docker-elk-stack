#!/bin/bash

# Start ElasticSearch
#MYIP="$( ip addr | grep "inet " | grep -v 127 | head -n1 | xargs | cut -f2 -d' ' | cut -f1 -d'/' )"
MYIP="$( ifconfig eth0 | grep -i "inet addr" | cut -f2 -d':' | cut -f1 -d' ' )"
if [ ! -e /opt/elasticsearch/config/elasticsearch.yml ]
then
  cp -f /opt/elasticsearch/config/elasticsearch-default.yml /opt/elasticsearch/config/elasticsearch.yml
  sed -i s@--MYIP--@$MYIP@g /opt/elasticsearch/config/elasticsearch.yml
fi

su elastic -c /opt/elasticsearch/bin/elasticsearch

