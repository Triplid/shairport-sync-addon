# Use pre-built Shairport Sync image with ALSA and MQTT support
FROM mikebrady/shairport-sync:latest

# Install dependencies for MQTT, ALSA, and Avahi
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

# Create directories for Avahi and D-Bus
RUN mkdir -p /var/run/dbus && \
    mkdir -p /var/run/avahi-daemon && \
    chown avahi:avahi /var/run/avahi-daemon

# Initialize udev and ALSA
RUN udevadm trigger --action=add /dev/snd && \
    alsactl init || echo "ALSA init failed: $?"

# Copy startup script
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Run Shairport Sync
CMD ["/run.sh"]
