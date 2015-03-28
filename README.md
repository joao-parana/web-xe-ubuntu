parana/web-xe-ubuntu
====================

Oracle Java JDK 8 plus Oracle Express Edition 11g Release 2 on Ubuntu 14.04.1 LTS

This **Dockerfile** is a [trusted build](https://registry.hub.docker.com/u/parana/web-xe-ubuntu/) of [Docker Registry](https://registry.hub.docker.com/).

### Based on: wnameless/oracle-xe-11g 

### Installation
```
docker pull parana/web-xe-ubuntu
```

Run with 80, 22 and 1521 ports opened:
```
docker run -d  -p 1443:80 -p 49160:22 -p 49161:1521 wnameless/oracle-xe-11g
```

Connect database with following setting:
```
hostname: localhost
port: 49161
sid: xe
username: system
password: oracle
```

Password for SYS & SYSTEM
```
oracle
```

Login by SSH
```
ssh root@localhost -p 49160
password: admin
```

Connect via WebBrowser with following setting:
```
hostname: localhost
port: 1443
username: soma
password: island
```

