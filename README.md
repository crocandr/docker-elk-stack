# LogStash Stack

You got 3 container basically with this stack.

  - logstash
  - elasticsearch
  - kibana

I use official containers for the ELK stack.

**The order of containers is important!** Because I use 'link' for connection between the containers.

# Elasticsearch

  - https://hub.docker.com/_/elasticsearch/

## Preconfig

```
mkdir -p /srv/elk-stack/elastic/config
cp -f elastic/files/elasticsearch-template.yml /srv/elk-stack/elastic/config/elasticsearch.yml
```

## Run

```
docker run -tid --name=elk-elastic -v /srv/elk-stack/elastic/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v /srv/elk-stack/elastic/data:/usr/share/elasticsearch/data elasticsearch
```

# LogStash

  - https://hub.docker.com/_/logstash/

## Preconfig

The logstash container communicates with the elasticsearch container, so You have to run the elastic container first!

```
mkdir -p /srv/elk-stack/logstash/config
cp -f logstash/files/logstash-template.conf /srv/elk-stack/logstash/config/logstash.conf
```

You can modify your logstash config file.

Basic config:

  - 5000 TCP+UDP for syslog
  - 5044 beats for logtash clients

## Run

```
docker run -tid --name=elk-logstash -v /srv/elk-stack/logstash/config/:/config -p 5000:5000 -p 5000:5000/udp -p 5044:5044 --link elk-elastic:elasticsrv logstash -f /config/logstash.conf
```

## First log message

You have to create a log message. This log message goes into the elasticsearch. Kibana can create indexes only in a non-empty elasticsearch DB.

```
echo "test" | nc 192.168.56.103 5000
```

# Kibana

  - https://hub.docker.com/_/kibana/

## Run

```
docker run -tid --name=elk-kibana -p 5601:5601 --link elk-elastic:elasticsearch kibana
```

# Usage

## View the logs

You can view your logs on the webUI of Kibana. The page accessible on IP and 5601 of your Docker host.  
I'm using the Docker in VirtualBox, so my IP and URL is: http://192.168.56.101:5601/

## Client

You can test the LogStash and the full stack with nc (netcat), or [FileBeat](https://www.elastic.co/downloads/beats/filebeat).

### netcat

```
# only a message
echo "this is my test" | nc -w1 -u 192.168.56.101 5000

# file in one message
cat myscript.log | nc -w1 -u 192.168.56.101 5000

# file line-by-line 
cat myscript.log | while read -r line; do echo "Script: $line" | nc -w1 -u 192.168.56.101 5000; done
```

### FileBeat

FileBeat works on all OS (Linux, Windows, OSX). Simple and easy log agent. But works with (r)syslog only.

Official page: https://www.elastic.co/downloads/beats/filebeat

Config:

Comment out (disable) the elasticsearch in your config. Maybe the LogStash target is better.

filebeat.yml:

```
...
      paths:
      #  - /var/log/*.log
        - /tmp/test.log
...
  ### Logstash as output
  logstash:
    # The Logstash hosts
    hosts: ["192.168.56.101:5000"]
...
```

Start:

```
./filebeat -c filebeat.yml -configtest
./filebeat -c filebeat.yml
```

But you can install FileBeat with rpm and/or deb package too. Maybe this method little bit easier.


# Extras

## Watcher

The [Watcher](https://www.elastic.co/products/watcher) is an alert plugin for Elasticsearch but you have to buy a license for this.  
You can enable watcher plugin for Elasticsearch with a 30 days long trial time.  
You need modify the elastic's Dockerfile (build file), you need uncomment the plugin installation lines.  
Example:  

elastic/Dockerfile:

```
...
# Watcher - Trial
RUN /opt/elasticsearch/bin/plugin install -b elasticsearch/license/latest
RUN /opt/elasticsearch/bin/plugin install -b elasticsearch/watcher/latest
...
```

... and now, you have to (re)build the elasticsearch container.


## Elastalert

Elasticalert container is optional. You can start this container if you need some alert about bad things in the log messages.

### Build

```
docker build -t logstash-ci/elastalert elastalert/
```

### Config

You need change template config with your own modification. When you restart the container (stop, start), the container uses your new config.

SMTP Config:  
You have to change these lines in your */srv/logci/elastalert/config/config-template.yaml* file. You have to give an available SMTP server in your network.

```
smtp_host: 192.168.1.254
smtp_port: 25
from_addr: noreply-elastalert@mycompany.com
```

...and you have to change the destination address, in the */srv/logci/elastalert/rules/myrule1.yaml* file:

```
  - "support@mycompany.com"
```

This rule file is only an example file for basic test!


At the first run, you need create data store folder and the template config on your docker host.

```
mkdir -p /srv/logci/elastalert/{rules,config}
cp -f elastalert/files/config-template.yaml /srv/logci/elastalert/config/
cp -f elastalert/files/rule-template.yaml-template /srv/logci/elastalert/rules/myrule1.yaml
```

Folders/files:

  - /srv/logci/elastalert/config/config-template.yaml - global config file of the elastalert
  - /srv/logci/elastalert/rules/ - store folder of the alert rules


### Run

```
docker run -tid --name=logci-elastalert -v /srv/logci/elastalert/rules:/opt/elastalert/rules -v /srv/logci/elastalert/config/config-template.yaml:/opt/elastalert/config-template.yaml --link
 logci-elastic:elasticsrv logstash-ci/elastalert /opt/start.sh
```
   
   
   
   
   
   
Good Luck!
