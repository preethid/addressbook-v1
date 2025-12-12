from tomcat:8.5.72-jdk8-openjdk-buster

env MAVEN_HOME /usr/share/maven
env MAVEN_VERSION 3.8.4

run apt-get install -y curl && \
    curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share && \
   mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
   ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

workdir /app

copy ./pom.xml /app/pom.xml
copy ./src /app/src

run mvn clean package

run cp /app/target/*.war /usr/local/tomcat/webapps/

expose 8080

cmd ["catalina.sh", "run"]