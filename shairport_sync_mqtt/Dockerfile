FROM ghcr.io/home-assistant/aarch64-base:latest
RUN apk add --no-cache \
    autoconf \
    automake \
    libtool \
    popt-dev \
    avahi \
    avahi-compat-libdns_sd \
    avahi-dev \
    dbus \
    dbus-libs \
    soxr \
    alsa-lib \
    alsa-lib-dev \
    alsa-utils \
    alsa-plugins \
    udev \
    git \
    build-base \
    cmake \
    libconfig-dev \
    openssl-dev \
    mosquitto-dev \
    mosquitto-libs
RUN git clone https://github.com/mikebrady/shairport-sync.git /tmp/shairport-sync && \
    cd /tmp/shairport-sync && \
    autoreconf -fi && \
    ./configure --sysconfdir=/etc --with-ssl=openssl --with-alsa --with-mqtt-client --with-avahi && \
    make && \
    make install && \
    rm -rf /tmp/shairport-sync
RUN mkdir -p /var/run/dbus && \
    mkdir -p /var/run/avahi-daemon && \
    chown avahi:avahi /var/run/avahi-daemon
RUN udevadm trigger --action=add /dev/snd && \
    alsactl init || echo "ALSA init failed: $?"
COPY run.sh /run.sh
RUN chmod a+x /run.sh
CMD ["/run.sh"]
