
FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y curl less vim net-tools

# JAVA
RUN curl --header "Cookie: oraclelicense=accept-securebackup-cookie" -L -o /opt/jre.tar.gz http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jre-8u91-linux-x64.tar.gz
RUN tar xzf /opt/jre.tar.gz -C /opt && ln -s -f /opt/jre1* /opt/java && ln -s -f /opt/java/bin/java /usr/local/bin

# ElasticSearch
RUN curl -L -o /opt/elasticsearch.tar.gz https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.3.1/elasticsearch-2.3.1.tar.gz
RUN tar xzf /opt/elasticsearch.tar.gz -C /opt && mv /opt/elasticsearch-* /opt/elasticsearch
# user for elasticsearch
RUN useradd -g users -s /bin/bash -m elastic
RUN chown elastic:users -R /opt/elasticsearch
RUN rm -f /opt/elasticsearch/config/elasticsearch.yml 

COPY files/start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
COPY files/elasticsearch-template.yml /opt/elasticsearch/config/elasticsearch-template.yml

