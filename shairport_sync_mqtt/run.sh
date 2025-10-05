#!/usr/bin/with-contenv bashio
# Запускаем D-Bus
dbus-daemon --system --nofork &

# Даём D-Bus время на запуск
sleep 2

# Запускаем avahi-daemon
avahi-daemon --no-drop-root --no-chroot --no-proc-title -D
sleep 2

# Используем существующий конфиг
CONFIG_PATH=/config/shairport-sync.conf
if [[ ! -f $CONFIG_PATH ]]; then
  echo "No config file found, creating default"
  cat > $CONFIG_PATH << EOF
general = {
    name = "My AirPlay Receiver";
};
diagnostics = {
    log_verbosity = 0;
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
# Запускаем Shairport Sync
exec shairport-sync -c $CONFIG_PATH
