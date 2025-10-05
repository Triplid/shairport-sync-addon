#!/usr/bin/with-contenv bashio
# Запускаем D-Bus
dbus-daemon --system --nofork &
sleep 2

# Запускаем avahi-daemon
avahi-daemon --no-drop-root --no-chroot --no-proc-title -D || echo "Avahi failed: $?"
sleep 2

# Проверяем конфиг
CONFIG_PATH=/config/shairport-sync.conf
echo "Using config file: $CONFIG_PATH"
cat $CONFIG_PATH

if [[ ! -f $CONFIG_PATH ]]; then
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
exec shairport-sync -c $CONFIG_PATH -v
