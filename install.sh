#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Run with sudo: sudo ./install.sh"
  exit 1
fi

THEME_NAME="GooglebookOS bootanimation"
THEME_DIR="/usr/share/plymouth/themes/$THEME_NAME"

echo "Installing $THEME_NAME..."

mkdir -p "$THEME_DIR"
cp -r pixel_gemini/* "$THEME_DIR/"

if command -v update-alternatives &> /dev/null; then
    update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth "$THEME_DIR/$THEME_NAME.plymouth" 100
    update-alternatives --set default.plymouth "$THEME_DIR/$THEME_NAME.plymouth"
    update-initramfs -u -k all
elif command -v plymouth-set-default-theme &> /dev/null; then
    plymouth-set-default-theme -R $THEME_NAME
fi

echo "Installed successfully!"
