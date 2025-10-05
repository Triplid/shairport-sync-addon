# Базовый образ для Home Assistant (ARM для HA Green)
ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest
FROM $BUILD_FROM

# Устанавливаем зависимости, включая dbus-libs
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
    git \
    build-base \
    cmake \
    libconfig-dev \
    openssl-dev \
    mosquitto-dev

# Создаём директории для Avahi и D-Bus
RUN mkdir -p /var/run/dbus && \
    mkdir -p /var/run/avahi-daemon && \
    chown avahi:avahi /var/run/avahi-daemon

# Компилируем Shairport Sync с поддержкой MQTT
RUN git clone https://github.com/mikebrady/shairport-sync.git /tmp/shairport-sync && \
    cd /tmp/shairport-sync && \
    autoreconf -fi && \
    ./configure --sysconfdir=/etc --with-ssl=openssl --with-alsa --with-mqtt-client --with-avahi && \
    make && \
    make install && \
    rm -rf /tmp/shairport-sync

# Копируем скрипт запуска
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Запускаем Shairport Sync
CMD ["/run.sh"]
