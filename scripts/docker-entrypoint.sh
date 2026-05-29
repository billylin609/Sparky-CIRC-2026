#!/bin/bash
set -e

# Source ROS2 setup
source /opt/ros/humble/setup.bash

# If workspace has been built, source it
if [ -f /ros2_ws/install/setup.bash ]; then
    source /ros2_ws/install/setup.bash
fi

# WSLg GUI: XDG_RUNTIME_DIR must be mode 0700, but the shared /mnt/wslg/runtime-dir
# is 0777, which Qt rejects. Use a private dir and link the WSLg Wayland socket in.
if [ -d /mnt/wslg/runtime-dir ]; then
    RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp/wslg-runtime}"
    mkdir -p "$RUNTIME_DIR"
    chmod 0700 "$RUNTIME_DIR"
    ln -sf /mnt/wslg/runtime-dir/wayland-0 "$RUNTIME_DIR/wayland-0" 2>/dev/null || true
fi

# Execute the command
exec "$@"