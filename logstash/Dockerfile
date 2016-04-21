
FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y curl less vim net-tools

# JAVA
RUN curl --header "Cookie: oraclelicense=accept-securebackup-cookie" -L -o /opt/jre.tar.gz http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jre-8u91-linux-x64.tar.gz
RUN tar xzf /opt/jre.tar.gz -C /opt && ln -s -f /opt/jre1* /opt/java && ln -s -f /opt/java/bin/java /usr/local/bin

# LogStash
RUN curl -L -o /opt/logstash.tar.gz https://download.elastic.co/logstash/logstash/logstash-all-plugins-2.3.1.tar.gz
RUN tar xzf /opt/logstash.tar.gz -C /opt && mv /opt/logstash-* /opt/logstash

COPY files/start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
COPY files/logstash-default.conf /opt/logstash

