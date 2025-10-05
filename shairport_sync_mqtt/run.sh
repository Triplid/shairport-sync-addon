#!/usr/bin/with-contenv bashio
# Проверяем права /dev/snd
echo "Checking /dev/snd permissions:"
ls -l /dev/snd || echo "Failed to list /dev/snd: $?"

# Проверяем наличие shairport-sync
echo "Checking shairport-sync binary:"
which shairport-sync || echo "shairport-sync not found: $?"
shairport-sync --version || echo "shairport-sync version check failed: $?"

# Запускаем D-Bus
echo "Starting D-Bus..."
dbus-daemon --system --nofork &
sleep 2
echo "D-Bus status: $?"

# Запускаем avahi-daemon
echo "Starting Avahi..."
avahi-daemon --no-drop-root --no-chroot --no-proc-title -D || echo "Avahi failed: $?"
sleep 2

# Проверяем ALSA устройства
echo "Available ALSA devices before init:"
aplay -l || echo "aplay failed: $?"
echo "ALSA init status:"
alsactl init || echo "ALSA init failed: $?"
echo "Available ALSA devices after init:"
aplay -l || echo "aplay failed: $?"

# Проверяем конфиг
CONFIG_PATH=/config/shairport-sync.conf
echo "Using config file: $CONFIG_PATH"
if [[ -f $CONFIG_PATH ]]; then
  cat $CONFIG_PATH
else
  echo "No config file found, creating default"
  cat > $CONFIG_PATH << EOF
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
    device = "hw:2,0";
    mixer_control_name = "PCM";
};
EOF
fi

# Запускаем Shairport Sync с отладкой
echo "Starting Shairport Sync..."
exec shairport-sync -c $CONFIG_PATH -v || echo "Shairport Sync failed: $?"
