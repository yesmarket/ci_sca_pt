FROM rabbitmq:3.7-management

ARG HTTP_PROXY

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY
ENV no_proxy localhost,127.0.0.1

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y curl unzip

RUN rabbitmq-plugins enable --offline rabbitmq_shovel rabbitmq_shovel_management

COPY ./plugins.sh /plugins.sh
RUN /plugins.sh
RUN rabbitmq-plugins enable --offline prometheus_rabbitmq_exporter

RUN curl https://dl.bintray.com/rabbitmq/community-plugins/3.7.x/rabbitmq_delayed_message_exchange/rabbitmq_delayed_message_exchange-20171201-3.7.x.zip > $RABBITMQ_HOME/plugins/rabbitmq_delayed_message_exchange-20171201-3.7.x.zip
RUN unzip /opt/rabbitmq/plugins/rabbitmq_delayed_message_exchange-20171201-3.7.x.zip -d /opt/rabbitmq/plugins
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange

