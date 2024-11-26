#!/bin/bash

# Exit immediately if any command fails
set -e

# Define variables
KEYSERVER="hkps://keys.openpgp.org"
KEY_ID="CF82A14B72843908"  # Replace with your actual key ID
WHL_FILE="devops_bot-0.1-py3-none-any.whl"
GPG_FILE="$WHL_FILE.gpg"

# Step 1: Ensure required tools are installed
echo "Checking for required tools..."
if ! command -v gpg &> /dev/null; then
    echo "Error: GPG is not installed. Please install it and try again."
    exit 1
fi

if ! command -v pip &> /dev/null; then
    echo "Error: pip is not installed. Please install it and try again."
    exit 1
fi

if ! command -v wget &> /dev/null; then
    echo "Error: wget is not installed. Please install it and try again."
    exit 1
fi

# Step 2: Fetch the public GPG key
echo "Fetching the public GPG key from the key server..."
gpg --keyserver "$KEYSERVER" --recv-keys "$KEY_ID"

# Step 3: Download the `.whl` and `.gpg` files
echo "Downloading the required files..."
wget -q "https://github.com/Devops-Bot-Official/DOB-Installation-Package/releases/download/latest/$WHL_FILE.gpg" -O "$GPG_FILE"
wget -q "https://github.com/Devops-Bot-Official/DOB-Installation-Package/releases/download/latest/$WHL_FILE" -O "$WHL_FILE"

# Step 4: Verify the file's signature
echo "Verifying the signature of $WHL_FILE..."
gpg --verify "$GPG_FILE" "$WHL_FILE"

if [ $? -ne 0 ]; then
    echo "Signature verification failed! The file may have been tampered with."
    exit 1
fi

echo "Signature verification successful!"

# Step 5: Install the package
echo "Installing the package..."
pip install "$WHL_FILE"

# Step 6: Cleanup
echo "Cleaning up temporary files..."
rm -f "$WHL_FILE" "$GPG_FILE"

echo "Installation complete!"

