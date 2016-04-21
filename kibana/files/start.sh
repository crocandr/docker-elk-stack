#!/bin/bash

KIBANADIR="/opt/kibana"

if [ ! -e $KIBANADIR/kibana.yml ]
then
  cp -f $KIBANADIR/kibana-default.yml $KIBANADIR/kibana.yml
fi

$KIBANADIR/bin/kibana -c $KIBANADIR/kibana.yml
