#!/usr/bin/with-contenv bashio
# Запускаем D-Bus
dbus-daemon --system --nofork &

# Даём D-Bus время на запуск
sleep 2

# Запускаем avahi-daemon
avahi-daemon --no-drop-root --no-chroot --no-proc-title -D
sleep 2

# Создаём конфиг, если отсутствует
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
    mqtt_host = "${MQTT_HOST:-core-mosquitto}";
    mqtt_port = ${MQTT_PORT:-1883};
    mqtt_uid = "${MQTT_USERNAME:-mqtt_user}";
    mqtt_pw = "${MQTT_PASSWORD:-mqtt_pass}";
    mqtt_id = "shairport-1";
    mqtt_topic_prefix = "${MQTT_TOPIC_PREFIX:-shairport}";
    sessioncontrol_topic = "sessioncontrol";
};
alsa = {
    enabled = "yes";
    device = "${DEVICE:-hw:2,0}";  # USB-аудиокарта
    mixer_control_name = "PCM";
};
EOF
fi
# Запускаем Shairport Sync
exec shairport-sync -c $CONFIG_PATH
