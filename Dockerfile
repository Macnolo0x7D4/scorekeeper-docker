FROM ubuntu:noble

ARG VERSION=2025-6.6.1
ARG APP="FTCLive $VERSION"
ARG APP_ZIP="$APP.zip"

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget apt-transport-https ca-certificates gnupg unzip sudo


RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public \
    | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null

RUN echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" \
    | tee /etc/apt/sources.list.d/adoptium.list

RUN apt-get update && apt-get install -y temurin-21-jdk

COPY $APP_ZIP /opt/$APP_ZIP

WORKDIR /opt
    
RUN unzip "$APP_ZIP" && \
    mv "$APP" ./scorekeeper && \
    rm -f $APP_ZIP

EXPOSE 80

ENTRYPOINT ["/opt/scorekeeper/FTCLauncher"]
