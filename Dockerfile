# Use a minimal image as parent
FROM openjdk:8-jdk-alpine

#RUN adduser -S -D jon
#RUN adduser -D -s /bin/bash jon
#USER jon

# Environment variables
ENV TOMCAT_MAJOR=8 \
    TOMCAT_VERSION=8.5.37 \
    CATALINA_HOME=/opt/tomcat

# init
RUN apk -U upgrade --update && \
    apk add curl && \
    apk add ttf-dejavu

RUN mkdir -p /opt

# install tomcat
RUN curl -jkSL -o /tmp/apache-tomcat.tar.gz http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
    gunzip /tmp/apache-tomcat.tar.gz && \
    tar -C /opt -xf /tmp/apache-tomcat.tar && \
    ln -s /opt/apache-tomcat-$TOMCAT_VERSION $CATALINA_HOME

# cleanup
RUN apk del curl && \
    rm -rf /tmp/* /var/cache/apk/*

EXPOSE 8080


ADD ./target/jpetstore.war $CATALINA_HOME/webapps/

ENTRYPOINT $CATALINA_HOME/bin/catalina.sh run

#ENTRYPOINT [ "startup.sh" ]

USER 1001

WORKDIR $CATALINA_HOME
