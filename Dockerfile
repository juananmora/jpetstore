FROM tomcat:8.5

LABEL maintainer="jamora@minsait.com"

ADD ./target/jpetstore.war $CATALINA_HOME/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
