FROM phusion/baseimage:0.11

ENV DEBIAN_FRONTEND noninteractive

# RUN echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list && \
#  printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable



RUN add-apt-repository ppa:wireguard/wireguard && apt update && \
 apt install -y --no-install-recommends \
 wireguard-tools \
 iptables \
 nano \
 net-tools \
 curl \
 iproute2 \
 iptables \
 dnsmasq \
 socat \
 && \
 curl -o /usr/bin/subspace https://github.com/subspacecloud/subspace/raw/master/subspace-linux-amd64 \
 && \
 apt clean

WORKDIR /scripts
ENV PATH="/scripts:${PATH}"
COPY install-module /scripts
COPY run /scripts
COPY genkeys /scripts
RUN chmod 755 /scripts/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/bin/subspace /usr/local/bin/entrypoint.sh

# CMD ["run"]

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD [ "/sbin/my_init" ]
