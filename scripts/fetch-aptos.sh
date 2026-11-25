#!/usr/bin/env sh
# Lädt die Schrift "Aptos" (Word-Standardschrift, Fließtext + Überschriften)
# von Microsoft nach fonts/aptos/. Sie darf nicht mit ins Repo (EULA),
# deshalb steht fonts/aptos/ in der .gitignore.
set -eu
cd "$(dirname "$0")/.."
url='https://download.microsoft.com/download/8/6/0/860a94fa-7feb-44ef-ac79-c072d9113d69/Microsoft%20Aptos%20Fonts.zip'
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL -o "$tmp/aptos.zip" "$url"
mkdir -p fonts/aptos
unzip -o -q -j "$tmp/aptos.zip" '*.ttf' -d fonts/aptos
echo "Aptos installiert in fonts/aptos/"
