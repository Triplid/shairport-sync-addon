#!/usr/bin/with-contenv bashio

CONFIG_PATH=/config/shairport-sync.conf

echo "[INIT] Starting D-Bus and Avahi..."
dbus-daemon --system --nofork &
sleep 2
avahi-daemon --no-drop-root --no-chroot --no-proc-title -D || echo "Avahi failed: $?"
sleep 2

# Создаем конфиг, если нет
if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "[INIT] No config found, creating default..."
  cat > "$CONFIG_PATH" << EOF
general = {
    name = "My AirPlay Receiver";
    output_backend = "alsa";
};

diagnostics = {
    log_verbosity = 3;
};

mqtt = {
    enabled = "yes";
    hostname = "192.168.0.123";    # IP брокера
    port = 1883;
    username = "tripl";
    password = "Fylhtq3120";
    client_id = "shairport_ha_green";
    topic = "Shairport";
    publish_raw = "no";
    publish_parsed = "yes";
    publish_cover = "yes";
    publish_volume = "yes";
    sessioncontrol_topic = "sessioncontrol";
};

alsa = {
    output_device = "default";  # или hw:2,0 для конкретной USB-карты
    mixer_control_name = "PCM";
    disable_synchronization = "no";
    use_mmap_if_available = "yes";
};
EOF
fi

echo "[INFO] ALSA devices available inside container:"
cat /proc/asound/cards || echo "No ALSA cards found!"
echo "Using config file: $CONFIG_PATH"
cat "$CONFIG_PATH"

echo "[START] Launching Shairport Sync..."
exec /usr/local/bin/shairport-sync -v -c "$CONFIG_PATH"
