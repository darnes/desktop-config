

Source of information:
https://nixos.org/manual/nixos/stable/index.html#sec-upgrading


```sh
sudo nix-channel --list

# add new (current new channel)
sudo nix-channel --add https://channels.nixos.org/nixos-25.11 nixos

# undo adding new:
sudo nix-channel --add https://channels.nixos.org/nixos-25.05 nixos

```
