
proper cleanup described [here](https://nixos.org/guides/nix-pills/11-garbage-collector.html)


# update packages
```sh

sudo nix-channel --update
sudo nixos-rebuild switch
sudo nixos-rebuild switch --upgrade
```

```sh
nix-channel --update
nix-env -u --always
rm /nix/var/nix/gcroots/auto/*
nix-collect-garbage -d
```


one-liner:
```sh

 sudo nix-channel --update && sudo nixos-rebuild switch --upgrade && sudo rm -rf /nix/var/nix/gcroots/auto/* && sudo nix-collect-garbage -d && sudo nixos-rebuild switch

```