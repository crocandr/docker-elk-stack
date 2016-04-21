
FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y curl less vim net-tools

# Kibana
RUN curl -L -o /opt/kibana.tar.gz https://download.elastic.co/kibana/kibana/kibana-4.5.0-linux-x64.tar.gz 
RUN tar xzf /opt/kibana.tar.gz -C /opt && mv /opt/kibana-* /opt/kibana

COPY files/start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
COPY files/kibana-default.yml /opt/kibana/kibana-default.yml

