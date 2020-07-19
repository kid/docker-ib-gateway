FROM bitnami/minideb:buster

ARG version=stable
ARG arch=x64

RUN install_packages ca-certificates curl procps socat unzip x11vnc xvfb
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

ARG S6_VERSION=v1.22.1.0
RUN curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz" \
  | tar xvzf - -C /
ENTRYPOINT ["/init"]


WORKDIR /root
RUN curl -L -s https://download2.interactivebrokers.com/installers/ibgateway/${version}-standalone/ibgateway-${version}-standalone-linux-${arch}.sh -o /tmp/gateway.sh \
 && chmod +x /tmp/gateway.sh \
 && /tmp/gateway.sh -q \
 && rm /tmp/gateway.sh

ARG IBC_VERSION=3.8.2
ENV INSTALL4J_ADD_VM_PARAMS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"
RUN curl -L -s "https://github.com/IbcAlpha/IBC/releases/download/${IBC_VERSION}/IBCLinux-${IBC_VERSION}.zip" -o /tmp/ibc.zip \
 && unzip /tmp/ibc.zip -d /opt/ibc \
 && chmod +x /opt/ibc/*.sh /opt/ibc/*/*.sh \
 && rm /tmp/ibc.zip

COPY rootfs /
ENV DISPLAY=":0"
EXPOSE 4002
EXPOSE 5900
