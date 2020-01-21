FROM sonarqube

ARG HTTP_PROXY

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY
ENV no_proxy localhost,127.0.0.1

USER root
RUN mkdir -p /usr/share/man/man1
RUN apt-get update && \
    apt-get install -y maven
RUN mvn dependency:get \
   -DremoteRepositories=https://mvnrepository.com/artifact/org.sonarsource.owasp/sonar-zap-plugin \
   -DgroupId=org.sonarsource.owasp \
   -DartifactId=sonar-zap-plugin -Dversion=1.2.0 \
   -Dtransitive=false
RUN cp /root/.m2/repository/org/sonarsource/owasp/sonar-zap-plugin/1.2.0/sonar-zap-plugin-1.2.0.jar /opt/sonarqube/extensions/plugins
USER sonarqube
