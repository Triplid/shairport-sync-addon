ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest
FROM $BUILD_FROM

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
    # Добавьте следующие пакеты:
    alsa-plugins \
    alsa-plugins-pulse \
    alsa-ucm-conf \
    git \
    build-base \
    cmake \
    libconfig-dev \
    openssl-dev \
    mosquitto-dev
# Create avahi user and group if they don't exist
RUN addgroup -S avahi 2>/dev/null || true && \
    adduser -S -D -G avahi avahi 2>/dev/null || true

# Create directories for Avahi and D-Bus
RUN mkdir -p /var/run/dbus && \
    mkdir -p /var/run/avahi-daemon && \
    chown avahi:avahi /var/run/avahi-daemon

# Initialize udev and ALSA
RUN udevadm trigger --action=add /dev/snd && \
    alsactl init || echo "ALSA init failed: $?"

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
