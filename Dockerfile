FROM mcr.microsoft.com/dotnet/core/sdk:3.1-bionic AS build

ARG SONAR_PROJECT_NAME
ARG SONAR_PROJECT_KEY
ARG SONAR_SECURITY_TOKEN
ARG WHITESOURCE_API_KEY
ARG HTTP_PROXY

ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY
ENV no_proxy localhost,127.0.0.1,sonarqube
ENV PATH "${PATH}:/root/.dotnet/tools"

RUN apt-get update && apt-get install -y openjdk-11-jre nodejs curl

RUN dotnet tool install --global dotnet-sonarscanner
RUN curl -LJO https://github.com/whitesource/unified-agent-distribution/releases/latest/download/wss-unified-agent.jar

WORKDIR /

COPY ./Galaxy.Template ./Galaxy.Template
COPY ./SonarQube.Analysis.xml /root/.dotnet/tools/.store/dotnet-sonarscanner/4.8.0/dotnet-sonarscanner/4.8.0/tools/netcoreapp3.0/any/SonarQube.Analysis.xml
COPY ./wss-unified-agent.config ./wss-unified-agent.config

RUN dotnet-sonarscanner begin /k:${SONAR_PROJECT_KEY} /n:${SONAR_PROJECT_NAME} /v:"1.0" /d:sonar.verbose=true

RUN dotnet restore /Galaxy.Template/src/Galaxy.Template.WebApi.Tests/Galaxy.Template.WebApi.Tests.csproj
RUN dotnet test /Galaxy.Template/src/Galaxy.Template.WebApi.Tests/Galaxy.Template.WebApi.Tests.csproj /p:CollectCoverage=true /p:CoverletOutputFormat=opencover

RUN dotnet restore /Galaxy.Template/src/Galaxy.Template.WebApi/Galaxy.Template.WebApi.csproj

RUN java -jar wss-unified-agent.jar -c ./wss-unified-agent.config -d ./Galaxy.Template -apiKey ${WHITESOURCE_API_KEY}

RUN dotnet publish /Galaxy.Template/src/Galaxy.Template.WebApi/Galaxy.Template.WebApi.csproj -c Release --self-contained false -o /opt/Galaxy.Template.WebApi

RUN dotnet-sonarscanner end
