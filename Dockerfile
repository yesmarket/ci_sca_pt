FROM mcr.microsoft.com/dotnet/core/sdk:3.1-bionic AS build

#ENV http_proxy http://r-directproxy.role:3128
#ENV https_proxy http://r-directproxy.role:3128
#ENV no_proxy localhost,127.0.0.1,sonarqube
ENV PATH "${PATH}:/root/.dotnet/tools"

RUN apt-get update && apt-get install -y openjdk-8-jre nodejs
RUN dotnet tool install --global dotnet-sonarscanner

WORKDIR /
COPY ./ASPNETCore-WebAPI-Sample ./ASPNETCore-WebAPI-Sample
COPY ./SonarQube.Analysis.xml /root/.dotnet/tools/.store/dotnet-sonarscanner/4.8.0/dotnet-sonarscanner/4.8.0/tools/netcoreapp3.0/any/SonarQube.Analysis.xml
WORKDIR /ASPNETCore-WebAPI-Sample

RUN dotnet-sonarscanner begin /k:"788ad7aa-84e6-4188-8eae-fa67ff6537ee" /n:"ASPNETCore-WebAPI-Sample" /v:"1.0" /d:sonar.verbose=true
RUN dotnet build SampleWebApiAspNetCore.sln
RUN dotnet-sonarscanner end
