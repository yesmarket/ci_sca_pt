FROM owasp/zap2docker-stable

ARG OAUTH_CLIENT_ID
ARG OAUTH_CLIENT_SECRET
ARG HTTP_PROXY

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY
ENV no_proxy localhost,127.0.0.1,template_webapi,keycloak

RUN echo ${OAUTH_CLIENT_ID}
RUN echo ${OAUTH_CLIENT_SECRET}

USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y jq
USER zap

RUN mkdir -p /zap/wrk
RUN ./zap.sh -addoninstall openapi -cmd

COPY ./auth.prop /zap/wrk/auth.prop

ARG CACHEBUST=1

RUN ACCESS_TOKEN=`curl -X POST -u "${OAUTH_CLIENT_ID}:${OAUTH_CLIENT_SECRET}" -d "grant_type=client_credentials" http://keycloak:8080/auth/realms/galaxy/protocol/openid-connect/token | jq '.access_token'` && \
    sed -i 's/$BEARER_TOKEN/'"$ACCESS_TOKEN"'/g' /zap/wrk/auth.prop
