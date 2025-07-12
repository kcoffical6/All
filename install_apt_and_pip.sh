#!/bin/bash

echo "🚀 Starting restoration process..."

# Step 1: Restore APT packages
echo "📦 Preparing APT packages list..."
cat all_installed_packages.txt | grep 'installed' | cut -d'/' -f1 > apt-packages.txt

echo "🔄 Updating APT..."
apt update

echo "📥 Installing APT packages..."
xargs -a apt-packages.txt apt install -y || {
    echo "⚠️ Some APT packages may have failed. Check manually."
}

# Step 2: Restore pip packages
echo "🐍 Preparing pip packages list..."
tail -n +3 pip_installed_packages.txt | awk '{print $1 "==" $2}' > pip-packages.txt

echo "📥 Installing Python3 and pip if not already present..."
apt install -y python3 python3-pip

echo "📦 Upgrading pip..."
pip3 install --upgrade pip

echo "📥 Installing pip packages..."
pip3 install -r pip-packages.txt || {
    echo "⚠️ Some pip packages may have failed. Check manually."
}

echo "✅ All done! APT and pip packages are restored."
