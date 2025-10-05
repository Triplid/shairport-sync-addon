ARG BUILD_FROM=multiarch/alpine-aarch64:latest
RUN apk add --no-cache \
    avahi \
    avahi-compat-libdns_sd \
    soxr \
    alsa-lib \
    alsa-utils \
    git \
    build-base \
    cmake \
    libconfig-dev \
    openssl-dev \
    libevent-dev \
    mosquitto-dev
RUN git clone https://github.com/mikebrady/shairport-sync.git /tmp/shairport-sync && \
    cd /tmp/shairport-sync && \
    autoreconf -fi && \
    ./configure --sysconfdir=/etc --with-ssl=openssl --with-tinymad --with-ao --with-alsa --with-pa --with-mqtt-client --with-systemd --with-avahi --with-mpris && \
    make && \
    make install && \
    cd / && rm -rf /tmp/shairport-sync
COPY run.sh /run.sh
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]
