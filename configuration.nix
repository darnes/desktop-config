# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /home/username/proj/desktop-setup/xremap/default.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  
  # following added for proper wake up from hibernation
  boot.resumeDevice = "/dev/disk/by-uuid/855dc0aa-2d3c-4f5b-8333-197b977e83bb";
  powerManagement.enable = true;
  
  services.power-profiles-daemon.enable = true;

  # action on closing lid 
  # options: poweroff/hibernate/suspend-then-hibernate ... 
  # https://search.nixos.org/options?channel=25.05&show=services.logind.lidSwitch&from=0&size=50&sort=relevance&type=packages&query=lidSwitch
  # services.logind.lidSwitch = "suspend-then-hibernate";
  
  services.logind.settings.Login.HandleLidSwitch = "suspend-then-hibernate";
  # Hibernate on power button pressed
  
  # services.logind.powerKey = "hibernate";
  services.logind.settings.Login.HandlePowerKey = "hibernate";
  # services.logind.powerKeyLongPress = "poweroff";
  services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";
  services.tailscale.enable = true;
  # Suspend first
  boot.kernelParams = ["mem_sleep_default=deep"];
  # battery management
  # services.tlp = {
  #  enable = true;
  # };
  # Define time delay for hibernation
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';

  # end of hibernation setup
  services.hardware.bolt.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.nameservers
  # networking.nameservers = ["100.119.51.107:30530"];  # doesn't do what I do expect
  
  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # services.xserver.displayManager.emptty.enable = true;
  # services.xserver.displayManager.ly.enable = true;
 
 # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = false;
  #services.desktopManager.gnome.enable = true;

  services.displayManager = {
    gdm.enable = false;
    # lightdm.enable = false;
  };

  #services.xserver.displayManager = {
  #  lightdm.enable = false;
  # };

  services.displayManager.ly.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.pki.certificates = [
    (builtins.readFile ./ca.pem)
  ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # users.extraUsers.ollama = {
  #   isSystemUser = true;
  #   group = "ollama";
  #   home = "/var/lib/ollama"; # Or another suitable home directory
  #   shell = "${pkgs.bash}/bin/bash"; # Or a restricted shell like "${pkgs.bash}/bin/rbash"
  # };
  # users.groups.ollama = {};

  # systemd.services.ollama = {
  #   enable = true;
  #   wantedBy = [ "multi-user.target" ];
  #   # after = [ "network-online.target" ];
  #   path = [ pkgs.ollama ];
  #   restartIfChanged = false;
  #   serviceConfig = {
  #     StateDirectory = "ollama";
  #     Restart = "on-failure";
  #     ExecStart = "${pkgs.ollama}/bin/ollama serve";
  #     DynamicUser = false;
  #     User = "ollama";
  #     Group = "ollama";
  #   };
  # };
  # check 
  # journalctl -u ollama
  
  services.xremap.enable = true;

  # systemd.services.xremap = {
  #   enable = true;
  #   wantedBy = [ "multi-user.target" ];
  #   # after = [ "network-online.target" ];
  #   path = [ pkgs.xremap ];
  #   restartIfChanged = true;
  #   serviceConfig = {
  #     # Environment = "RUST_LOG=debug";
  #     Restart = "on-failure";
  #     ExecStart = "${pkgs.xremap}/bin/xremap /home/username/.config/xremap/config.yml";
  #     # DynamicUser = true;
  #     # User = "username";
  #     # Group = "users";
  #   };
  # };
  systemd.services.for-hibernate = {
    enable = true;
    wantedBy = ["hibernate.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/rmmod intel_hid";
      ExecStop = "${pkgs.kmod}/bin/modprobe intel_hid";
      RemainAfterExit = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.username = {
    isNormalUser = true;
    description = "username";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      
      # llm 
      # ollama
    #  thunderbird
      openssl
      dig
      zsh
      jq

      virtualenv
      uv # claim to be quick pip replacement, build with rust
      python313
      python313Packages.pip

      # python3Full # provides 3.12
      # python312Packages.pip

      stripe-cli
      vscode
      libreoffice # office package
      ripgrep # nvchad deps
      # cc
      # since v 50 required by hyprland
      gcc
      libgcc
      gnumake
      cmake
      extra-cmake-modules

      # clang 
      # cl
      unzip
      zip
      zig # end of nvchad deps
      # network and general debug
      traceroute
      lm_sensors
      stress

    ];
  };

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    # following is tested and works
    docker = {
      enable = true;
      extraOptions = ''
        --insecure-registry home-server:6443 --insecure-registry harbor.local
      '';
    };
    #podman = {
    #  enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      # dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      #defaultNetwork.settings.dns_enabled = true;
    #};
  };

  # Install firefox.
  programs.firefox.enable = true;
  # programs.ssh.startAgent = true;
  hardware.bluetooth.enable = true; # should be on bu default with 25.11
  services.blueman.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # screenshot - maker
    pkgs.sway-contrib.grimshot

    # office stuff
    zoom-us
    # emptty # isn't confgured https://github.com/NixOS/nixpkgs/issues/220022 can re-iterate if will have time later
    # lightdm
    fzf # fuzzy search in current dir and in shell history.. handy tool
    tailscale
    kubernetes-helm
    kustomize
    kubectl 
    kubectx
    k9s
    # swayfx
    slack
    brightnessctl
    blueman
    hyprpaper
    hyprlock
    mongosh # not installed yet
    ly
    pciutils
    xfce.thunar
    killall
    htop
    vim
    chromium
    google-chrome
    neovim
    kitty
    wofi
    waybar
    networkmanagerapplet # network manager
    xremap
    whitesur-cursors
    libnotify # for notify-send 
    swaynotificationcenter # for swaync
    starship
    # dev-related
    git
    bun
    yarn
    nodejs
    # podman deps
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    #podman-compose # start group of containers for dev
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
#  wget
    cifs-utils # samba-mount
  ];

# sway config
 programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = pkgs.swayfx;
};

#  fonts.packages = with pkgs; [
#    #  nerdfonts
#    nerd-fonts.fira-code
#    nerd-fonts.droid-sans-mono
#    nerd-fonts.jetbrains-mono 
#    font-awesome
#  ];

#----=[ Fonts ]=----#
fonts = {
  enableDefaultPackages = true;
  packages = with pkgs; [ 
   nerd-fonts.fira-code                                                                                 
    nerd-fonts.droid-sans-mono                                                                           
    nerd-fonts.jetbrains-mono                                                                            
    font-awesome
  ];

  # fontconfig = {
  #  defaultFonts = {
  #    serif = [  "Liberation Serif" "Vazirmatn" ];
  #    sansSerif = [ "Ubuntu" "Vazirmatn" ];
  #    monospace = [ "Ubuntu Mono" ];
  #  };
  # };
};

# fonts.fontconfig.antialias = false;
  programs.hyprland= {
    enable = true;
    # withUWSM = true;
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1"; # required for slack but for something else as well
    # required for numpy - not really
    # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    # export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"
  };

  # Enable common container config files in /etc/containers
  # virtualisation.containers.enable = true;
  #virtualisation = {
  #  podman = {
  #    enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
  #    dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
  #    defaultNetwork.settings.dns_enabled = true;
  #  };
  # };

  # users.users.username = {
  #  isNormalUser = true;
  #  extraGroups = [ "podman" ];
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # trying flake from xremap


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # following is tested and works
  # services.openssh = {
  #    enable = true;
  #    settings = {
  #      PasswordAuthentication = true;
  #	AllowUsers = null;
  #	UseDns = true;
  #	X11Forwarding = false;
  #	PermitRootLogin = "yes";
  #    };
  # };
  networking.extraHosts =
  ''
    # 192.168.1.127 rp4
    # 192.168.1.107 s
    # 100.119.51.107 s vlogs.local vmselect.local grafana.local questdb.local harbor.local webui.local
    # 192.168.1.107 vlogs.local
    # 192.168.1.107 vmselect.local
    # 192.168.1.107 grafana.local
'';

   # For mount.cifs, required unless domain name resolution is not needed.
  # environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/share" = {
    device = "//192.168.1.107/public";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };
 
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh; 
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    
    # dotDir = "/home/username/.zshrc";
    # enableAutosuggestions = true;
    
    autosuggestions = {
      enable = true;
      strategy = ["completion" "history"];
    };
    # enables search based on entered value
    # historySubstringSearch.enable = true;
    interactiveShellInit = "source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh";

    syntaxHighlighting.enable = true;
   
    
    #zplug = {
    #  enable = true;
    #  plugins = [
    #    { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
    #    # { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
    #  ];
    #};
    shellAliases = {
    #  # ll = "ls -l";
    #  update = "sudo nixos-rebuild switch";
    };
    # history.size = 10000;
  };
  #fileSystems."/mnt/share-private" = {
  #  device = "//192.168.1.107/private";
  #  fsType = "cifs";
  #  options = let
  #    # this line prevents hanging on network split
  #    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

  #  in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
