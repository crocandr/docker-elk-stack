#!/bin/bash

KIBANADIR="/opt/kibana"

cp -f $KIBANADIR/kibana-template.yml $KIBANADIR/kibana.yml

$KIBANADIR/bin/kibana -c $KIBANADIR/kibana.yml
