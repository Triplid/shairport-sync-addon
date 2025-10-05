#!/usr/bin/with-contenv bashio

# Check /dev/snd permissions
echo "[INIT] Checking /dev/snd permissions:"
ls -l /dev/snd || echo "Failed to list /dev/snd: $?"

# Check shairport-sync binary
echo "[INIT] Checking shairport-sync binary:"
which shairport-sync || echo "shairport-sync not found: $?"
shairport-sync --version || echo "shairport-sync version check failed: $?"

# Start D-Bus
echo "[INIT] Starting D-Bus..."
dbus-daemon --system --nofork &
sleep 2
echo "[INIT] D-Bus status: $?"

# Start Avahi
echo "[INIT] Starting Avahi..."
avahi-daemon --no-drop-root --no-chroot --no-proc-title -D || echo "Avahi failed: $?"
sleep 2

# Check ALSA devices
echo "[INFO] ALSA devices available inside container (before init):"
cat /proc/asound/cards || echo "No ALSA cards found (cat /proc/asound/cards failed)!"
aplay -l || echo "aplay failed: $?"
echo "[INFO] ALSA init status:"
alsactl init || echo "ALSA init failed: $?"
echo "[INFO] ALSA devices available inside container (after init):"
cat /proc/asound/cards || echo "No ALSA cards found (cat /proc/asound/cards failed)!"
aplay -l || echo "aplay failed: $?"

# Check configuration
CONFIG_PATH=/config/shairport-sync.conf
echo "[INFO] Using config file: $CONFIG_PATH"
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
    device = "hw:2,0";
    mixer_control_name = "PCM";
};
EOF
fi
cat "$CONFIG_PATH"

# Start Shairport Sync
echo "[START] Launching Shairport Sync..."
exec /usr/local/bin/shairport-sync -v -c "$CONFIG_PATH" || echo "Shairport Sync failed: $?"
