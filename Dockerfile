FROM mcr.microsoft.com/devcontainers/base:bookworm

ARG IVY_ENGINE_DOWNLOAD_URL=https://dev.axonivy.com/permalink/dev/axonivy-engine-slim.zip
ARG IVY_HOME=/usr/lib/axonivy-engine

RUN apt-get update && \
    apt-get install -y wget unzip && \
    rm -rf /var/lib/apt/lists/* && \
    \
    wget ${IVY_ENGINE_DOWNLOAD_URL} -O /tmp/ivy.zip --no-verbose && \
    unzip /tmp/ivy.zip -d ${IVY_HOME} && \
    rm -f /tmp/ivy.zip && \
    \
    mkdir ${IVY_HOME}/applications && \
    mkdir ${IVY_HOME}/configuration/applications && \
    chown -R vscode:0 ${IVY_HOME} && \
    \
    chmod -R g=u ${IVY_HOME}

RUN wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /usr/share/keyrings/adoptium.asc && \
    echo "deb [signed-by=/usr/share/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list && \
    apt-get update && apt-get install -y temurin-17-jdk maven && \
    apt-get purge -y wget && \
    apt-get clean
