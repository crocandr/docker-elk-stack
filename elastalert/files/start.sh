#!/bin/bash

ELASTALERTDIR="/opt/elastalert"

# Start ElasticSearch
#MYIP="$( ip addr | grep "inet " | grep -v 127 | head -n1 | xargs | cut -f2 -d' ' | cut -f1 -d'/' )"
MYIP="$( ifconfig eth0 | grep -i "inet addr" | cut -f2 -d':' | cut -f1 -d' ' )"

cp -f $ELASTALERTDIR/config-template.yaml $ELASTALERTDIR/config.yaml

#python $ELASTALERTDIR/elastalert/elastalert.py --config $ELASTALERTDIR/config.yaml --verbose
cd $ELASTALERTDIR && python elastalert/elastalert.py --config config.yaml --verbose
#/bin/bash
