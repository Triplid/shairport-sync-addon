# Используем готовый образ Shairport Sync с поддержкой ALSA и MQTT
FROM mikebrady/shairport-sync:latest

# Устанавливаем зависимости для MQTT, ALSA и Avahi
RUN apk add --no-cache \
    dbus \
    dbus-libs \
    avahi \
    avahi-compat-libdns_sd \
    avahi-dev \
    mosquitto-libs \
    mosquitto-dev \
    alsa-lib \
    alsa-lib-dev \
    alsa-utils \
    alsa-plugins \
    soxr \
    udev \
    libconfig-dev

# Создаём директории для Avahi и D-Bus
RUN mkdir -p /var/run/dbus && \
    mkdir -p /var/run/avahi-daemon && \
    chown avahi:avahi /var/run/avahi-daemon

# Инициализируем udev и ALSA
RUN udevadm trigger --action=add /dev/snd && \
    alsactl init || echo "ALSA init failed: $?"

# Копируем скрипт запуска
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Запускаем Shairport Sync
CMD ["/run.sh"]
