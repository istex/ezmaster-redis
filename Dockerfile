FROM redis:5.0.4


# need jq to parse JSON
# netcat to wait for when mongo is ready to listen
# tmpreaper to cleanup old dump
# python for a basic http server used for ezmaster
# vim for debug stuff
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y install netcat jq tmpreaper vim python

COPY config.json /
COPY docker-entrypoint.overload.sh /usr/local/bin/

# redis data folder dedicated to ezmaster
# because it's not yet (8 nov 2017) possible to UNVOLUME /data/db and /data/configdb
RUN mkdir -p /ezdata/db && chown -R redis:redis /ezdata/db

# backup stuff
RUN mkdir -p /ezdata/dump/
COPY dump.periodically.sh /usr/local/bin/

# basic http server stuff
RUN mkdir /www
COPY index.* /www/

# ezmasterization of ezmaster-redis
# see https://github.com/CamilleBarge/test-ezmaster-redis/
# notice: httpPort is useless here but as ezmaster require it (v3.8.1) we just add a wrong port number
RUN echo '{ \
  "httpPort": 8080, \
  "configPath": "/config.json", \
  "configType": "json", \
  "dataPath": "/ezdata", \
  "technicalApplication": true \
}' > /etc/ezmaster.json

# --dir = Working directory, where DB will be written with default filename dump.rdb
CMD [ "redis-server", "--dir", "../ezdata/db" ]

ENTRYPOINT [ "docker-entrypoint.overload.sh" ]

