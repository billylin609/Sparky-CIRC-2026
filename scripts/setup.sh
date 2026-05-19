#!/bin/bash

# Auto-setup script for Docker user permissions
# This script detects the current user's UID/GID and creates a .env file
# for docker-compose to use the correct user mapping

set -e

echo "🔧 Setting up Docker environment for user permissions..."

# Get current user info
CURRENT_USER=$(whoami)
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

echo "📋 Detected user: $CURRENT_USER (UID: $CURRENT_UID, GID: $CURRENT_GID)"

# Create .env file with current user's info
cat > .env << EOF
# Auto-generated environment variables for Docker user mapping
# This file is created by setup.sh and should not be edited manually

USER_ID=$CURRENT_UID
GROUP_ID=$CURRENT_GID
USERNAME=$CURRENT_USER
EOF

echo "✅ Created .env file with your user settings"

# Pre-create workspace directories so Docker doesn't create them as root
mkdir -p build install log
echo "✅ Created workspace directories (build, install, log)"

# Handle directories that may have been previously created by Docker as root
if [ "$(stat -c '%U' build)" != "$CURRENT_USER" ] || \
   [ "$(stat -c '%U' install)" != "$CURRENT_USER" ] || \
   [ "$(stat -c '%U' log)" != "$CURRENT_USER" ]; then
    echo ""
    echo "⚠️  Some directories are not owned by you (likely created by Docker as root)."
    echo "   Fix with: sudo chown -R \$USER:\$USER build install log"
fi

echo ""
echo "🚀 Setup complete! You can now run:"
echo "   docker-compose up -d"
echo ""
echo "📝 This setup will work for any user on any machine."