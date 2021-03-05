FROM tomcat:8.5

LABEL maintainer="jamora@minsait.com"

ADD ./target/jpetstore.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
