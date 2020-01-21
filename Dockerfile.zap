FROM owasp/zap2docker-stable

ARG OAUTH_CLIENT_ID
ARG OAUTH_CLIENT_SECRET
ARG HTTP_PROXY

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY
ENV no_proxy localhost,127.0.0.1,template_webapi,keycloak

WORKDIR /zap

USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y jq nodejs
USER zap

RUN wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip && \
    unzip sonar-scanner-cli-4.2.0.1873-linux.zip

COPY ./sonar-scanner.properties /zap/sonar-scanner-4.2.0.1873-linux/conf/sonar-scanner.properties

ENV PATH "${PATH}:/zap/sonar-scanner-4.2.0.1873-linux/bin"

RUN mkdir -p /zap/wrk
RUN ./zap.sh -addoninstall openapi -cmd

COPY ./auth.prop /zap/wrk/auth.prop
COPY ./zap-api-scan.sh ./zap-api-scan.sh

ARG CACHEBUST=1

RUN ACCESS_TOKEN=`curl -X POST -u "${OAUTH_CLIENT_ID}:${OAUTH_CLIENT_SECRET}" -d "grant_type=client_credentials" http://keycloak:8080/auth/realms/galaxy/protocol/openid-connect/token | jq '.access_token'` && \
    sed -i 's/$BEARER_TOKEN/'"$ACCESS_TOKEN"'/g' /zap/wrk/auth.prop

#ENTRYPOINT ["zap-api-scan.sh"]
