#!/bin/bash

LOGSTASHDIR="/opt/logstash"

# Default config
if [ ! -e /opt/logstash/logstash.conf ]
then
  cp -f $LOGSTASHDIR/logstash-default.conf $LOGSTASHDIR/logstash.conf
fi

# Start logstash
$LOGSTASHDIR/bin/logstash -f $LOGSTASHDIR/logstash.conf

