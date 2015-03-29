# Dependencia: http://dockerfile.github.io/#/ubuntu
# FROM dockerfile/ubuntu
FROM wnameless/oracle-xe-11g

# Responsável
MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

# Install build-essential, software-properties-common, byobu, curl, 
# git, htop, man, unzip, vim and wget
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# Install dev tools: jdk, git etc...
# Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# RUN apt-get install -y mvn

# Add files.
# ADD root/.bashrc /root/.bashrc
# ADD root/.gitconfig /root/.gitconfig
# ADD root/.scripts /root/.scripts

RUN ls -la /root
RUN ls -la /bin
RUN echo 'service oracle-xe start' > /bin/start-oracle
##  RUN echo 'su oracle -c "/u01/app/oracle/product/11.2.0/xe/bin/lsnrctl status"' >> /bin/start-oracle
RUN echo 'echo "Please execute: tnsping XE ; lsnrctl start"' >> /bin/start-oracle
RUN echo 'su oracle -c "/bin/bash"' >> /bin/start-oracle
RUN chmod a+rx /bin/start-oracle

# RUN echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/bash.bashrc
# RUN echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc
# RUN echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc
RUN ls -la /u01/app/oracle/product/11.2.0/xe 
RUN ls -la /sbin
RUN cat /etc/bash.bashrc
# Define working directory.
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
RUN echo $JAVA_HOME
RUN echo `java -version`
RUN sed -i -E "s/HOST = [^)]+/HOST = db-server/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
RUN sed -i -E "s/HOST = [^)]+/HOST = db-server/g" /u01/app/oracle/product/11.2.0/xe/network/admin/tnsnames.ora

# Add a definition for db-server in /etc/hosts
RUN echo $(grep $(hostname) /etc/hosts | cut -f1) db-server >> /etc/hosts     
# Define default command which start Oracle XE 
# CMD sed -i -E "s/HOST = [^)]+/HOST = db-server/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora ; service oracle-xe start

RUN cat /bin/start-oracle
USER root
RUN cat /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
RUN cat /u01/app/oracle/product/11.2.0/xe/network/admin/tnsnames.ora
CMD /bin/start-oracle
# ; echo HOSTNAME = $HOSTNAME ; echo "Please execute: lsnrctl status ; tnsping XE ; " ; su oracle -c "/bin/bash"  
# ; /usr/sbin/sshd -D

# To Create the image use: docker build -rm  -t="parana/web-xe-ubuntu" . 
# To Run the image use: 
# docker run -h db-server -d -p 1443:80 -p 4460:22 -p 1521:1521  --name myxe parana/web-xe-ubuntu 
# ssh root@192.168.59.103  -p 4460 and use passwd admin
# To DEBUG run the command: docker exec myxe whatever-command 
# Execute /bin/start-oracle when prompt shell apear
# To test with sqlplus use: sqlplus system/oracle@192.168.59.103:1521/XE
#