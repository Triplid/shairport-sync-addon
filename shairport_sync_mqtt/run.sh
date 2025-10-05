#!/usr/bin/with-contenv bashio
#!/usr/bin/env bash
CONFIG_PATH=/config/shairport-sync.conf
if [[ ! -f $CONFIG_PATH ]]; then
  echo "No config file found, creating default"
  cat > $CONFIG_PATH << EOF
general = {
    name = "My AirPlay Receiver";
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
    device = "${DEVICE:-hw:0,0}";
    mixer_control_name = "PCM";
};
EOF
fi
exec shairport-sync -c $CONFIG_PATH
