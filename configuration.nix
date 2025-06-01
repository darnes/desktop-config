# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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
  services.logind.lidSwitch = "suspend-then-hibernate";
  # Hibernate on power button pressed
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";

  # Suspend first
  boot.kernelParams = ["mem_sleep_default=deep"];

  # Define time delay for hibernation
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';

  # end of hibernation setup

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.displayManager = {
    gdm.enable = false;
    lightdm.enable = false;
  };

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
  systemd.services.xremap = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    # after = [ "network-online.target" ];
    path = [ pkgs.xremap ];
    restartIfChanged = true;
    serviceConfig = {
      # Environment = "RUST_LOG=debug";
      Restart = "on-failure";
      ExecStart = "${pkgs.xremap}/bin/xremap /home/username/.config/xremap/config.yml";
      # DynamicUser = true;
      # User = "username";
      # Group = "users";
    };
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.username = {
    isNormalUser = true;
    description = "username";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
      vscode
      ripgrep # nvchad deps
      # cc
      gcc
      clang 
      cl
      unzip
      zip
      zig # end of nvchad deps
    ];
  };

  # Enable common container config files in /etc/containers
  # virtualisation.docker.enable = true;
  virtualisation.containers.enable = true;
  virtualisation = {
    docker = {
      enable = true;
    };
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      # dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.ssh.startAgent = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # emptty # isn't confgured https://github.com/NixOS/nixpkgs/issues/220022 can re-iterate if will have time later
    # lightdm
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
  ];
  
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
  programs.hyprland.enable = true;
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
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
