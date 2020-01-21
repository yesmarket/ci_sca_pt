FROM sonarqube

ARG HTTP_PROXY

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY
ENV no_proxy localhost,127.0.0.1

USER root
#RUN mkdir -p /usr/share/man/man1
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y wget
#RUN mvn dependency:get \
#   -DremoteRepositories=https://mvnrepository.com/artifact/org.sonarsource.owasp/sonar-zap-plugin \
#   -DgroupId=org.sonarsource.owasp \
#   -DartifactId=sonar-zap-plugin -Dversion=1.2.0 \
#   -Dtransitive=false
#RUN cp /root/.m2/repository/org/sonarsource/owasp/sonar-zap-plugin/1.2.0/sonar-zap-plugin-1.2.0.jar /opt/sonarqube/extensions/plugins
RUN wget -P /opt/sonarqube/extensions/plugins https://github.com/Coveros/zap-sonar-plugin/releases/download/sonar-zap-plugin-1.2.0/sonar-zap-plugin-1.2.0.jar
RUN wget -P /opt/sonarqube/extensions/plugins https://github.com/dependency-check/dependency-check-sonar-plugin/releases/download/2.0.1/sonar-dependency-check-plugin-2.0.1.jar
USER sonarqube
