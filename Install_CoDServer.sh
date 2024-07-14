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

echo "Creating user for CodServer..."
if ! id codserver &>/dev/null; then
    useradd -r -s /usr/bin/nologin codserver
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
