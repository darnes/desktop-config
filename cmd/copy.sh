#!/usr/bin/env bash

rm -rf ./waybar
echo "copying files..."

# cp /etc/nixos/configuration.nix ./

#sed 's/${USER}/username/g' /etc/nixos/configuration.nix 
sed 's/'"$USER"'/username/g' /etc/nixos/configuration.nix> configuration.nix  

# zshrc 
cp ~/.zshrc ./zshrc

cp -r ~/.config/hypr ./
cp -r ~/.config/waybar ./
cp -r ~/.config/kitty ./
cp -r ~/.config/xremap ./

cp ~/.config/starship.toml ./

# code

cp ~/.config/Code/User/settings.json ./code/
cp ~/.config/Code/User/keybindings.json ./code/

