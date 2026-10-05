#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Run with sudo: sudo ./install.sh"
    exit 1
fi

THEME_NAME="GooglebookOS_bootanimation"
THEME_DIR="/usr/share/plymouth/themes/$THEME_NAME"

echo "Installing $THEME_NAME..."

mkdir -p "$THEME_DIR"
cp -r pixel_gemini/* "$THEME_DIR/"

if command -v plymouth-set-default-theme &> /dev/null; then
    plymouth-set-default-theme -R "$THEME_NAME"
elif command -v update-alternatives &> /dev/null; then
    update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth "$THEME_DIR/$THEME_NAME.plymouth" 100
    update-alternatives --set default.plymouth "$THEME_DIR/$THEME_NAME.plymouth"
    if command -v update-initramfs &> /dev/null; then
        update-initramfs -u -k all
    fi
elif command -v dracut &> /dev/null; then
    dracut --regenerate-all --force
elif command -v mkinitcpio &> /dev/null; then
    mkinitcpio -P
fi

echo "Installed successfully!"
