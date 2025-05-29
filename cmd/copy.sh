#!/usr/bin/env bash

rm -rf ./waybar
echo "copying files..."

# cp /etc/nixos/configuration.nix ./

#sed 's/${USER}/username/g' /etc/nixos/configuration.nix 
sed 's/'"$USER"'/username/g' /etc/nixos/configuration.nix> configuration.nix  

cp -r ~/.config/hypr ./
cp -r ~/.config/waybar ./
cp -r ~/.config/kitty ./
cp -r ~/.config/xremap ./

cp ~/.config/starship.toml ./

