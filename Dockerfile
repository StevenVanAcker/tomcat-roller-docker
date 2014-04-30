FROM ubuntu:12.04

RUN apt-get update 
RUN apt-get --yes install default-jdk build-essential vim wget libmysql-java mysql-server

RUN useradd -m -d /home/roller -s /bin/bash roller

USER roller

WORKDIR /home/roller
RUN wget -O tomcat.tar.gz http://apache.spinellicreations.com/tomcat/tomcat-7/v7.0.53/bin/apache-tomcat-7.0.53.tar.gz
RUN tar -xf tomcat.tar.gz
RUN ln -s apache-tomcat-* tomcat

RUN wget -O roller.tar.gz http://mirrors.axint.net/apache/roller/roller-5/v5.0.1/bin/roller-weblogger-5.0.1-for-tomcat.tar.gz
RUN tar -xf roller.tar.gz
RUN ln -s roller-weblogger*/ roller

WORKDIR /home/roller/tomcat/conf
RUN sed -i 's:name="localhost":name="0.0.0.0":g' server.xml 

WORKDIR /home/roller
RUN cp roller/webapp/roller-5.0.1-tomcat.war tomcat/webapps/
ADD mysql.txt /home/roller/mysql.txt
ADD roller-custom.properties /home/roller/apache-tomcat-7.0.53/lib/roller-custom.properties
ADD tomcat-users.xml /home/roller/apache-tomcat-7.0.53/conf/tomcat-users.xml
RUN mkdir -p data/mediafiles data/searchindex

WORKDIR /home/roller/tomcat/lib
RUN ln -s /usr/share/java/mysql.jar mysql.jar
RUN wget http://repo2.maven.org/maven2/javax/mail/mail/1.4.1/mail-1.4.1.jar
RUN wget http://repo2.maven.org/maven2/javax/activation/activation/1.1.1/activation-1.1.1.jar

WORKDIR /home/roller/
USER root
RUN chown -R roller:roller .

WORKDIR /home/roller/tomcat
EXPOSE 8080 

CMD ( /usr/sbin/mysqld & ) && echo "Sleeping 5 seconds to allow MySQL to start" && sleep 5 && mysql < /home/roller/mysql.txt && su -c ./bin/startup.sh roller && /bin/bash
