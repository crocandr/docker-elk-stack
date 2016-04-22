# LogStash Stack

You got 3 container basically with this stack.

  - logstash
  - elasticsearch
  - kibana

All apps downloaded from the [Official Elastic Webpage](https://www.elastic.co/).


**The order of containers is important!** Because I use 'link' for connection between the containers.

# Elasticsearch

## Build

```
docker build -t logstash-ci/elastic elastic/
```

## Run

At the first run, you need create data store folder and the template config on your docker host.

```
mkdir -p /srv/logci/elastic/{data,config}
chmod 777 /srv/logci/elastic/data
cp -f elastic/files/elasticsearch-template.yml /srv/logci/elastic/config/elasticsearch-template.yml
```

You can change template config with your own modification. When you restart the container (stop, start), the container uses your new config.

```
docker run -tid --name=logci-elastic -v /srv/logci/elastic/data:/opt/elasticsearch/data -v /srv/logci/elastic/config/elasticsearch-template.yml:/opt/elasticsearch/config/elasticsearch-template.yml logstash-ci/elastic /opt/start.sh
```

The elastic's start.sh change your default.yml. The start.sh insert the actual IP into this config file and start the elasticsearch. 
This is little bit complicated now, maybe, but I will change this configuration method.

# LogStash

## Build

```
docker build -t logstash-ci/logstash logstash/
```

## Run

At the first run, you need create log folder and the template config on your docer host. You can store received logs with logstash, and you can store in the elasticsearch too. This is your choice. :)

```
mkdir -p /srv/logci/logstash/{data,config}
chmod 777 /srv/logci/elastic/data
cp -f logstash/files/logstash-template.conf /srv/logci/logstash/config/logstash-template.conf
```

You can change template config with your own modification. When you restart the container (stop, start), the container uses your new config.

```
docker run -tid --name=logci-logstash -v /srv/logci/logstash/data:/srv/logstash -v /srv/logci/logstash/config/logstash-template.conf:/opt/logstash/logstash-template.conf -p 5000:5000 -p 5000:5000/udp -p 5044:5044 --link logci-elastic:elasticsrv logstash-ci/logstash /opt/start.sh
```

# Kibana

## Build

```
docker build -t logstash-ci/kibana kibana/
```

## Run

At the first run, you need create data store folder and the template config on your docker host.

```
mkdir -p /srv/logci/kibana/config
cp -f kibana/files/kibana-template.yml /srv/logci/kibana/config/kibana-template.yml
```

You can change template config with your own modification. When you restart the container (stop, start), the container uses your new config.

```
docker run -tid --name=logci-kibana -v /srv/logci/kibana/config/kibana-template.yml:/opt/kibana/kibana-template.yml -p 5601:5601 --link logci-elastic:elasticsrv logstash-ci/kibana /opt/start.sh
```

# Usage

## View the logs

You can view your logs on the web of the Kibana. The page accessible on IP and 5601 of your Docker host.  
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




Good Luck!
