FROM bitnami/minideb:buster

ARG version=stable
ARG arch=x64

RUN install_packages ca-certificates curl unzip x11vnc xvfb
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

ARG S6_VERSION=v1.22.1.0
RUN curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz" \
  | tar xvzf - -C /
ENTRYPOINT ["/init"]

ARG IBC_VERSION=3.4.0
ENV INSTALL4J_ADD_VM_PARAMS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"
RUN curl -L -s "https://github.com/ib-controller/ib-controller/releases/download/3.4.0/IBController-3.4.0.zip" -o /tmp/ibcontroller.zip \
 && unzip /tmp/ibcontroller.zip -d /opt/IBController \
 && chmod -R +x /opt/IBController/*.sh \
 && chmod -R +x /opt/IBController/Scripts/*.sh \
 && rm /tmp/ibcontroller.zip

RUN sed -i -e 's/TWS_MAJOR_VRSN=963/TWS_MAJOR_VRSN=972/' /opt/IBController/IBControllerGatewayStart.sh

WORKDIR /root
RUN curl -L -s https://download2.interactivebrokers.com/installers/ibgateway/${version}-standalone/ibgateway-${version}-standalone-linux-${arch}.sh -o /tmp/gateway.sh \
 && chmod +x /tmp/gateway.sh \
 && /tmp/gateway.sh -q \
 && rm /tmp/gateway.sh

COPY rootfs /
ENV DISPLAY=":0"
EXPOSE 4000
EXPOSE 4001
EXPOSE 5900
