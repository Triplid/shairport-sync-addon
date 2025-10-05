# Указываем базовый образ для Home Assistant (ARM для HA Green)
ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest
FROM $BUILD_FROM

# Устанавливаем зависимости
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
