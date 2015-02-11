# Dockerfile for Osmose-backend 

## Info

This Dockerfile creates a developer environment for osmose-backend 

based on:
- Ubuntu 14.04
- PostgreSQL 9.4 + PostGIS 2.1 
- openjdk-7-jre-headless

## Install

- install [docker](https://docker.com) 
- start ./docker_build.sh


## Usage

create export directory   `/docker_export` 

```bash
sudo docker run -it  -v /docker_export:/docker_export  osmose-backend-dev  /bin/bash
```

or 

```bash
./docker_start.sh
```

### after connections

```bash
-/start.sh
```

or 

```bash
service postgresql start & 
./local-launcher luxembourg
```

and check logs
-  /data/work/osmose/logs


## Persistance

 ....  not yet ...


## Meta

Build with 
- docker version `1.5`
- osmose  https://github.com/osm-fr/osmose-backend  ( master : 2015.feb.11 )

## References

- https://github.com/osm-fr/osmose-backend 
- http://wiki.openstreetmap.org/wiki/Osmose
- http://wiki.openstreetmap.org/wiki/Osmose/erreurs
- Docker documentation [docs.docker.com](https://docs.docker.com/)

