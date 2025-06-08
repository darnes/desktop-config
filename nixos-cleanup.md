
proper cleanup described [here](https://nixos.org/guides/nix-pills/11-garbage-collector.html)


```sh
nix-channel --update
nix-env -u --always
rm /nix/var/nix/gcroots/auto/*
nix-collect-garbage -d
```
