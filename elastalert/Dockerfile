
FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y curl less vim net-tools

RUN apt-get install -y python python-dateutil python-elasticsearch python-yaml python-boto python-simplejson gcc make python2.7-dev python-setuptools

RUN curl -L -o /opt/elastalert.tar.gz https://github.com/Yelp/elastalert/archive/v0.0.80.tar.gz 
RUN tar xzf /opt/elastalert.tar.gz -C /opt && mv /opt/elastalert-* /opt/elastalert
RUN cd /opt/elastalert/ && python setup.py install

COPY files/start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
COPY files/config-template.yaml /opt/elastalert/config-template.yml

