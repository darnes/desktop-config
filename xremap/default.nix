{ config, lib, pkgs, ...  }:
  let
    cfg = config.services.xremap;
  in
{
  options.services.xremap = {
    enable = lib.mkEnableOption "X-Remap service is enabled";
    # tbd: enable optional debug - see current config
    
    # I suspect that shi allows add package, but I'm not sure that it is
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.xremap;
      description = "xremap service or its replacement ";
    };

    optionConfigFilePath = lib.mkOption {
      type = lib.types.str;
      # default = "~/.config/xremap/config.yml";
      default = "/home/dima/.config/xremap/config.yml";
      description = "path to configuration file to use in service";
    };


    
  };

  config = lib.mkIf cfg.enable {
    systemd.services.xremap = {
      # Description = "XRemap service for proper remap super key";
      wantedBy = [ "multi-user.target" ];
      # after = [ "network-online.target" ];
      restartIfChanged = true;
      serviceConfig = {
        # Environment = "RUST_LOG=debug"; # TBD: add if condition here, apart of that great job;
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/xremap ${cfg.optionConfigFilePath}";
      };
    };

  };
}
