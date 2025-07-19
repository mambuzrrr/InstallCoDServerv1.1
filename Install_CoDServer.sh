# CHANGE MADE OVER THE ORIGINAL SCRIPT: /usr/sbin/nologin is used instead of /usr/bin/nologin (fix for ubuntu server). Include the installation of a few necessary binaries
# Ensure that you run this script in /data (i.e. your PWD is /data). If this directory doesn't exist, create it.
# You can configure the passwords/guns/weapons/game-mode etc in /data/myserver/main/myserver.cfg

# Installing a fresh Call of Duty 1 1.1 Server with a Script, fastest and Easiest way to Install a CoDServer (1.1).
# Scripted by Brejax (www.devlxue.eu)
# After Installation, you can configure your things, dont forgot to open the "startmyserver.sh" script, to add your IP & Port.
# Before starting the "Install_CoDServer.sh" script, make sure you have givin the Permissions to the script with: chmod +x Install_CoDServer.sh

# <------------------>
#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root. Use sudo."
    exit 1
fi

mkdir -p /data
cd /data

apt update
apt install unzip
# Some of these might fail    
sudo apt install -y \
  lib32z1 \
  libc6:i386 \
  libstdc++6:i386 \
  libncurses5:i386 \
  libz1:i386 \
  lib32z1 \
  libx11-6:i386 \
  libxext6:i386 \
  libgcc1:i386 \
  libxau6:i386 \
  libxdmcp6:i386 \
  libxcb1:i386 \
  libuuid1:i386 \
  libcurl3-gnutls:i386 \
  libcurl4:i386
echo "Creating user for CodServer..."
if ! id codserver &>/dev/null; then
    useradd -r -s /usr/sbin/nologin codserver
    echo "User 'codserver' created."
else
    echo "User 'codserver' already exists. Skipping creation."
fi

DOWNLOAD_URL="https://www.devluxe.eu/dl/Call%20of%20Duty%201/Serverfiles/myserver.zip"

INSTALL_DIR=$(pwd)

echo ""
echo "Installing Call of Duty server..."
echo ""

echo "Downloading myserver.zip from $DOWNLOAD_URL"
echo ""

wget -q --show-progress $DOWNLOAD_URL

if [ $? -ne 0 ]; then
    echo "Error: Failed to download myserver.zip. Exiting."
    exit 1
fi

echo ""
echo "Download complete. Extracting server..."
echo ""

unzip -q myserver.zip

if [ $? -ne 0 ]; then
    echo "Error: Failed to extract myserver.zip. Exiting."
    exit 1
fi

echo ""
echo "Extraction complete. Applying permissions and settings..."
echo ""

chown -R codserver:codserver $INSTALL_DIR/myserver
find $INSTALL_DIR/myserver -type d -exec chmod 0770 {} \;
find $INSTALL_DIR/myserver -type f -exec chmod 0660 {} \;
chmod u+x $INSTALL_DIR/myserver/cod_lnxded $INSTALL_DIR/myserver/startmyserver.sh

echo ""
echo "Setup complete. The Call of Duty server is installed and configured in $INSTALL_DIR/myserver."

echo ""
echo "Changing the IP to 0.0.0.0 (open to all over the public internet) and port to 28960 in /data/myserver/startmyserver.sh..."

echo ""
echo "Change the server configuration by navigating to /data/myserver/main/myserver.cfg"

cat << 'EOF' > startmyserver.sh
#!/bin/sh
exec su -s /bin/sh codserver -- <<-COD
HOME=/data/myserver
LD_PRELOAD=/data/myserver/codextended.so /data/myserver/cod_lnxded +set dedicated 2 +set fs_homepath /data/myserver +set fs_basepath /data/myserver +set net_ip 0.0.0.0 +set net_port 28960 +set sv_maxclients 32 +set ttycon 0 +set developer 0 +exec myserver.cfg +map mp_harbor
COD
EOF

