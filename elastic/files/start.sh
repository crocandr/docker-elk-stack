#!/bin/bash

ELASTICDIR="/opt/elasticsearch/"

# Start ElasticSearch
#MYIP="$( ip addr | grep "inet " | grep -v 127 | head -n1 | xargs | cut -f2 -d' ' | cut -f1 -d'/' )"
MYIP="$( ifconfig eth0 | grep -i "inet addr" | cut -f2 -d':' | cut -f1 -d' ' )"

cp -f $ELASTICDIR/config/elasticsearch-template.yml $ELASTICDIR/config/elasticsearch.yml
sed -i s@--MYIP--@$MYIP@g $ELASTICDIR/config/elasticsearch.yml

su elastic -c /opt/elasticsearch/bin/elasticsearch

