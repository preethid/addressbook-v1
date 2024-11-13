FROM maven:3.8.4-openjdk-11-slim AS build-stage

workdir /app

copy ./pom.xml  ./pom.xml
copy ./src      ./src
copy ./settings.xml  ./settings.xml

Run mvn package
Run mvn -U deploy -s settings.xml

FROM tomcat:8.5.78-jdk11-openjdk-slim

COPY --from=build-stage /app/target/*.war /usr/local/tomcat/webapps/

expose 8080

CMD ["catalina.sh", "run"]

