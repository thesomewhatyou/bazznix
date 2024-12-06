{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./kde
  ];

  config =
    lib.mkIf (
      config.bazznix.desktop.kde.enable
    ) {
      boot = {
        consoleLogLevel = 0;
        initrd.verbose = false;
        plymouth.enable = true;
      };

      environment = {
        sessionVariables.NIXOS_OZONE_WL = "1";

        systemPackages = with pkgs; [
          adwaita-icon-theme
          liberation_ttf
        ];
      };

      hardware.logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };

      home-manager.sharedModules = [
        {
          stylix = {
            iconTheme = {
              enable = true;
              dark = "Papirus-Dark";
              light = "Papirus";
              package = pkgs.papirus-icon-theme.override {color = "adwaita";};
            };
          };
        }
      ];

      programs = {
        dconf = {
          enable = true;

          profiles.user.databases = [
            {
              settings = {
                "org/gnome/desktop/wm/preferences".button-layout =
                  if config.bazznix.desktop.kde.enable
                  then "appmenu:minimize,maximize,close"
                  else "appmenu:close";

                "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
                "org/gtk/settings/file-chooser".sort-directories-first = true;
              };
            }
          ];
        };

        system-config-printer.enable = true;
      };

      services = {
        gnome.gnome-keyring.enable = true;
        gvfs.enable = true; # Mount, trash, etc.

        libinput.enable = true;

        pipewire = {
          enable = true;

          alsa = {
            enable = true;
            support32Bit = true;
          };

          pulse.enable = true;
        };

        printing.enable = true;
        system-config-printer.enable = true;

        xserver = {
          enable = true;
          excludePackages = with pkgs; [xterm];
        };
      };
    };
}
