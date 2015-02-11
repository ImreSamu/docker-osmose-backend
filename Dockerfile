FROM ubuntu:14.04
#
# trusty 
# Developer settings for https://github.com/osm-fr/osmose-backend
# PostgreSQL settings not secure!
# 
MAINTAINER ......
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update
RUN apt-get -y install wget
RUN wget --quiet --no-check-certificate -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list
RUN apt-get -y update &&  apt-get -y upgrade
RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
RUN apt-get -y install postgresql-9.4 postgresql-contrib-9.4 postgresql-9.4-postgis-2.1 postgis
RUN echo "host    all             all             0.0.0.0/0           md5" >> /etc/postgresql/9.4/main/pg_hba.conf
RUN service postgresql start &&\
     /bin/su postgres -c "createuser -d -s -r -l osmose" &&\
     /bin/su postgres -c "psql postgres -c \"ALTER USER osmose WITH ENCRYPTED PASSWORD '-osmose-'\"" &&\
     /bin/su postgres -c "psql postgres -c \"CREATE DATABASE osmose ENCODING 'UTF8'    \"" &&\
     /bin/su postgres -c "psql postgres -c \"GRANT ALL PRIVILEGES ON DATABASE osmose to osmose    \"" &&\
     /bin/su postgres -c "psql postgres -d osmose -c \"CREATE EXTENSION postgis;       CREATE EXTENSION hstore;    \"" &&\
     /bin/su postgres -c "psql postgres -d osmose -c \"CREATE EXTENSION fuzzystrmatch; CREATE EXTENSION unaccent;  \"" &&\
     service postgresql stop
     
RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.4/main/postgresql.conf
RUN echo "port = 5432"            >> /etc/postgresql/9.4/main/postgresql.conf
## pg_hba.conf  trust
RUN sed -i 's/md5/trust/g'   /etc/postgresql/9.4/main/pg_hba.conf
RUN sed -i 's/peer/trust/g'  /etc/postgresql/9.4/main/pg_hba.conf
EXPOSE 5432

# Test postgresql settings ----
RUN service postgresql start &&\
    PGPASSWORD=-osmose-  psql -d osmose -Uosmose --command " SELECT now(); "  &&\
    service postgresql stop
      
# -------  install tools -----------
RUN apt-get install -y python-software-properties
RUN apt-get install -y mc tar git curl nano wget sudo python python-pip curl
RUN apt-get install -y dialog net-tools 

# -------  install python -----------
RUN pip install xmltodict
RUN apt-get install -y libpython-dev
RUN apt-get install -y python-dev python-distribute \ 
   python-dateutil python-imposm-parser python-lockfile python-polib \ 
   python-poster python-psycopg2 python-shapely python-nose 

# -------- install osmose-backend --------
RUN mkdir -p  /data/work/osmose/logs
RUN mkdir -p  /data/project/osmose/backend/
WORKDIR /data/project/osmose/
RUN git clone https://github.com/osm-fr/osmose-backend.git backend

# --------  install java -------------- 
RUN apt-get install -y openjdk-7-jre-headless

# --------  set work dir ------------
WORKDIR /data/project/osmose/backend

ADD start.sh   ./start.sh
RUN chmod 0755 ./start.sh

