#!/usr/bin/with-contenv bashio

CONFIG_PATH=/config/shairport-sync.conf

echo "[INIT] Starting D-Bus and Avahi..."
dbus-daemon --system --nofork &
sleep 2
avahi-daemon --no-drop-root --no-chroot --no-proc-title -D || echo "Avahi failed: $?"
sleep 2

if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "[INIT] No config found, creating default..."
  cat > "$CONFIG_PATH" << EOF
general = {
    name = "My AirPlay Receiver";
};

diagnostics = {
    log_verbosity = 3;
};

mqtt = {
    enabled = "yes";
    hostname = "192.168.0.123";
    port = 1883;
    username = "tripl";
    password = "Fylhtq3120";
    client_id = "shairport-1";
    topic = "shairport";
    publish_raw = "no";
    publish_parsed = "yes";
    publish_cover = "no";
    publish_volume = "yes";
    sessioncontrol_topic = "sessioncontrol";
};

alsa = {
    enabled = "yes";
    device = "default";  # автоматически выберет нужную карту
    mixer_control_name = "none";
};
EOF
fi

echo "[INFO] ALSA devices available inside container:"
cat /proc/asound/cards || echo "No ALSA cards found!"
echo "Using config file: $CONFIG_PATH"
cat "$CONFIG_PATH"


echo "[START] Launching Shairport Sync..."
exec /usr/local/bin/shairport-sync -v -c "$CONFIG_PATH"
