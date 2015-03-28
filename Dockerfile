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

# Add files.
# ADD root/.bashrc /root/.bashrc
# ADD root/.gitconfig /root/.gitconfig
# ADD root/.scripts /root/.scripts

# RUN echo 'export ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe' >> /etc/bash.bashrc
# RUN echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc
# RUN echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc
RUN ls -la /u01/app/oracle/product/11.2.0/xe/bin
RUN ls -la /bin
RUN cat /etc/bash.bashrc
RUN ps -ef | grep -i xe
# Define working directory.
# WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
# RUN /etc/init.d/oracle-xe start
RUN echo $JAVA_HOME
RUN echo `javac -version`

# Define default command which start Oracle XE 
CMD sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora; \
    service oracle-xe start; \
    /usr/sbin/sshd -D

RUN cat /u01/app/oracle/product/11.2.0/xe/network/admin/listener.ora
# To Create the image use: docker build -t="parana/web-xe-ubuntu" . 
# To Run the image use: 
# docker run -d -p 1443:80 -p 49160:22 -p 49161:1521 parana/web-xe-ubuntu 
# 