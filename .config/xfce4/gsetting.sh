#!/usr/bin/env bash
set -euo pipefail

### === KONFIGURASI ===
GTK_THEME="Gruvbox-Dark"
ICON_THEME="Tela-circle"
CURSOR_THEME="Bibata-Modern-Ice"

### === XFCE BUTUH DELAY SEBELUM XSETTINGS SIAP ===
sleep 2

### === HELPER: apply xfconf jika property belum ada ===
apply_xfconf() {
    local channel="$1"
    local prop="$2"
    local type="$3"
    local value="$4"

    if xfconf-query -c "$channel" -p "$prop" &>/dev/null; then
        xfconf-query -c "$channel" -p "$prop" -s "$value"
    else
        xfconf-query -c "$channel" -p "$prop" --create -t "$type" -s "$value"
    fi
}

### === GTK / ICON / CURSOR THEME ===
apply_xfconf xsettings /Net/ThemeName string "$GTK_THEME"
apply_xfconf xsettings /Net/IconThemeName string "$ICON_THEME"
apply_xfconf xsettings /Gtk/CursorThemeName string "$CURSOR_THEME"
apply_xfconf xsettings /Gtk/PreferDarkTheme bool true

### === GNOME GTK4 CONSISTENCY ===
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME" 2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme prefer-dark 2>/dev/null || true

### === WINDOW MANAGER THEME ===
apply_xfconf xfwm4 /general/theme string "$GTK_THEME"
