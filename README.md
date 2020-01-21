# Overview

This repo is POC for;
1. Dockerfile build integration to a) SonarQube/Cloud, and b) WhiteSource.
2. Automated pentesting with Zaproxy.

SonarQube/Cloud is a static analysis tool used to detect; a) bugs, b) vulnerabilities, and c) code smells. It also checks for code duplications as well as unit test code coverage.

WhiteSource is used to detect and alert on CVEs in open source packages, as well as potential licencing issues.

Zaproxy is a OWASP pentesting tool that has capability to do automated scans of web APIs (facilitated by crawling specified OpenAPI spec).

# Instructions

## Sonar & WhiteSource

Firstly pull down the Galaxy.Template submodule and then run `git submodule update --init --recursive`.

If you don't have SonarCloud, you can run SonarQube locally (requires docker) as follows (*note; need to create a docker network, so that sonar scanner can talk to SonarQube during build*):
```
docker network create -d bridge sonar
docker run \
   -p 9000:9000 \
   --name=sonarqube \
   --network=sonar \
   sonarqube
```

You should be able to access SonarQube at [http://localhost:9000](http://localhost:9000), or http://sonarqube:9000 for containers on the same 'sonar' docker network.

Alternatively, if you want to use [SonarCloud](http://sonarcloud.io), you'll need to update `SonarQube.Analysis.xml` appropriately as well as add a `/d:sonar.login="enter-key-here"` argument to `dotnet-sonarscanner begin` in the Dockerfile.

In SonarQube/Cloud create a project and note down the project `Name` and `Key` - you'll need these as build args for the next step.

To run the build follow the example below;
```
docker build ^
   -f Dockerfile.build \
   --build-arg SONAR_PROJECT_NAME=Galaxy.Template \
   --build-arg SONAR_PROJECT_KEY=4ea3aa28-a9b0-45d9-ba6c-acffa7244b33 \
   --build-arg WHITESOURCE_API_KEY=redacted \
   --build-arg HTTP_PROXY=http://proxy:8080 \
   --build-arg CACHEBUST=$(date) \
   --network=sonar \
   -t gt \
   .
```

If you need to debug anything, you can run & exec into the container as follows:
```
docker run -it --network=sonar gt /bin/bash
```

## Zaproxy

To build the zaproxy image follow the example below. *Note: you'll need to join the docker network where Keycloak is running.*
```
docker build \
   -f Dockerfile.zap \
   --build-arg OAUTH_CLIENT_ID=template \
   --build-arg OAUTH_CLIENT_SECRET=3adbbd35-2ba3-4dc6-8710-bed320346f7d \
   --build-arg HTTP_PROXY=http://proxy:8080 \
   --build-arg CACHEBUST=$(date)
   --network=security \
   -t zaproxy \
   .
```
```
docker run -t --network=services zaproxy \
   zap-api-scan.py \
   -t http://template_webapi:10000/swagger.json \
   -f openapi \
   -O template_webapi:10000 \
   -r ./zap-report.html \
   -z "-configfile /zap/wrk/auth.prop"
```

To get the report, you can run the following PowerShell command;

```
iex "docker cp $(docker ps -l -q):/zap/wrk/zap-report.html C:\git\sonarconfig"
```
^^ replace host path as required.

If you need to debug anything, you can run & exec into the container as follows:
```
docker run -it --network=services zaproxy /bin/bash
```
