#!/bin/bash

# make sure the directory exists
mkdir -p /opt/rabbitmq/plugins
cd /opt/rabbitmq/plugins

# Downloads prometheus_rabbitmq_exporter and its dependencies with curl

readonly base_url='https://github.com/deadtrickster/prometheus_rabbitmq_exporter/releases/download/v3.7.2.4'

get() {
  curl -LO "$base_url/$1"
}

get accept-0.3.3.ez
get prometheus-3.5.1.ez
get prometheus_cowboy-0.1.4.ez
get prometheus_httpd-2.1.8.ez
get prometheus_rabbitmq_exporter-3.7.2.4.ez
