#!/usr/bin/with-contenv bashio

CONFIG_PATH=/config/shairport-sync.conf

# -------------------------------------------------
# 1. Запускаем системные службы, нужные Shairport
# -------------------------------------------------
echo "[INIT] Starting D-Bus and Avahi..."
dbus-daemon --system --nofork &
sleep 2
avahi-daemon --no-drop-root --no-chroot --no-proc-title -D || echo "Avahi failed: $?"
sleep 2

# -------------------------------------------------
# 2. Проверяем и при необходимости создаем конфиг
# -------------------------------------------------
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
    mqtt_host = "core-mosquitto";
    mqtt_port = 1883;
    mqtt_uid = "tripl";
    mqtt_pw = "Fylhtq3120";
    mqtt_id = "shairport-1";
    mqtt_topic_prefix = "shairport";
    sessioncontrol_topic = "sessioncontrol";
};

alsa = {
    enabled = "yes";
    device = "default";  # автоматически выберет нужную карту
    mixer_control_name = "none";
};
EOF
fi

# -------------------------------------------------
# 3. Диагностика звука
# -------------------------------------------------
echo "[INFO] ALSA devices available inside container:"
cat /proc/asound/cards || echo "No ALSA cards found!"
echo "Using config file: $CONFIG_PATH"
cat "$CONFIG_PATH"

# -------------------------------------------------
# 4. Запуск Shairport Sync
# -------------------------------------------------
echo "[START] Launching Shairport Sync..."
exec /usr/local/bin/shairport-sync -v -c "$CONFIG_PATH"
