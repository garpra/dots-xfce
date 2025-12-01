#!/bin/bash

# Tentukan folder tujuan
FOLDER=~/Pictures/Screenshots

# Cek dan buat folder jika belum ada
mkdir -p "$FOLDER"

# Ambil screenshot fullscreen dan simpan di folder tersebut
xfce4-screenshooter -f -s "$FOLDER/screenshot-$(date +%Y%m%d-%H%M%S).png"
