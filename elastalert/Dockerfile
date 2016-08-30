
FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y curl less vim net-tools git unzip

RUN apt-get install -y python gcc make python2.7-dev python-setuptools python-pip
RUN apt-get install -y python-dateutil python-elasticsearch python-yaml python-boto python-simplejson python-croniter python-tlslite-ng python-gnutls python-tlsh

#RUN curl -L -o /opt/elastalert.tar.gz https://github.com/Yelp/elastalert/archive/v0.0.80.tar.gz 
#RUN curl -L -o /opt/elastalert.tar.gz https://github.com/Yelp/elastalert/archive/v0.0.76.tar.gz
RUN curl -L -o /opt/elastalert.tar.gz https://github.com/Yelp/elastalert/archive/v0.0.95.tar.gz
RUN tar xzf /opt/elastalert.tar.gz -C /opt && mv /opt/elastalert-* /opt/elastalert
RUN cd /opt/elastalert/ && python setup.py install
#RUN cd /opt/elastalert/ && python setup.py install && pip install -r requirements.txt

#RUN curl -L -o /opt/elastalert.zip https://github.com/Yelp/elastalert/archive/master.zip
#RUN unzip /opt/elastalert.zip -d /opt && mv /opt/elastalert-master /opt/elastalert
#RUN cd /opt/elastalert/ && ls -hal && pwd && python setup.py install

COPY files/start.sh /opt/start.sh
RUN chmod +x /opt/start.sh
COPY files/config-template.yaml /opt/elastalert/config-template.yml

