#!/bin/bash

LOGSTASHDIR="/opt/logstash"

cp -f $LOGSTASHDIR/logstash-template.conf $LOGSTASHDIR/logstash.conf

# Start logstash
$LOGSTASHDIR/bin/logstash -f $LOGSTASHDIR/logstash.conf

