self: {
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./apps
    ./desktop
    ./options.nix
    ./services
    ./shell
  ];
  config = lib.mkIf config.bazznix.enable {
    bazznix = {
      desktop.kde.enable = lib.mkDefault true;

      apps = {
        emudeck.enable = lib.mkDefault true;
        podman.enable = lib.mkDefault true;
        steam.enable = lib.mkDefault true;
      };

      services.flatpak.enable = lib.mkDefault true;
    };

    environment = {
      systemPackages = with pkgs; [
        heroic
        lutris
      ];

      variables.FLAKE = lib.mkDefault "github:alyraffauf/bazznix";
    };

    programs = {
      dconf.enable = true;

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      nh.enable = true;
    };

    networking.networkmanager.enable = true;

    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 14d";
        persistent = true;
        randomizedDelaySec = "60min";
      };

      # Run GC when there is less than 100MiB left.
      extraOptions = ''
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';

      optimise.automatic = true;

      settings = {
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];

        substituters = [
          "https://alyraffauf.cachix.org"
          "https://bazznix.cachix.org"
          "https://cache.nixos.org/"
          "https://chaotic-nyx.cachix.org/"
          "https://jovian-nixos.cachix.org"
          "https://nix-community.cachix.org"
          "https://nix-gaming.cachix.org"
        ];

        trusted-public-keys = [
          "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
          "bazznix.cachix.org-1:DbV2pJFAzHipBYsfr3csAHaIKRMZ8+XTJJ/ljglBU14="
          "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
          "jovian-nixos.cachix.org-1:mAWLjAxLNlfxAnozUjOqGj4AxQwCl7MXwOfu7msVlAo="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];

        trusted-users = ["aly"];
      };
    };

    nixpkgs = {
      config.allowUnfree = true; # Allow unfree packages
      overlays = [self.overlays.default];
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;

        publish = {
          enable = true;
          addresses = true;
          userServices = true;
          workstation = true;
        };
      };

      handheld-daemon = {
        enable = true;

        package = with pkgs;
          handheld-daemon.overrideAttrs (oldAttrs: {
            propagatedBuildInputs =
              oldAttrs.propagatedBuildInputs
              ++ [pkgs.adjustor];
          });

        ui.enable = true;
        user = config.bazznix.user;
      };

      openssh = {
        enable = true;
        openFirewall = true;
        settings.PasswordAuthentication = false;
      };
    };

    system.autoUpgrade = {
      enable = lib.mkDefault true;
      allowReboot = false;
      dates = "02:00";
      flags = ["--accept-flake-config"];
      flake = config.environment.variables.FLAKE;
      operation = "switch";
      persistent = true;
      randomizedDelaySec = "60min";

      rebootWindow = {
        lower = "02:00";
        upper = "06:00";
      };
    };
  };
}
