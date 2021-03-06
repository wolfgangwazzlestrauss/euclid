#!/usr/bin/env bash


# Change background picture.
gsettings set org.gnome.desktop.background picture-uri "file:///home/$1/Pictures/background/white_and_gray_mountains.jpg"
# Use Pop (Light) color theme.
gsettings set org.gnome.desktop.interface gtk-theme Pop
# Show battery percentage in activity bar.
gsettings set org.gnome.desktop.interface show-battery-percentage true
# Do not show pop up banners for notifications.
gsettings set org.gnome.desktop.notifications show-banners false
# Use natural scroll orientation for mouse.
gsettings set org.gnome.desktop.peripherals.mouse natural-scroll true
# Use natural scroll orientation for touchpad.
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true

# Show hidden files in Nautilus Files application.
gsettings set org.gtk.Settings.FileChooser show-hidden true
gsettings set org.gnome.nautilus.preferences show-hidden-files true

# Turn off automatic brightness
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
