{
  lib,
  osConfig,
  ...
}: {
  options.ar.home = {
    apps = {
      fastfetch.enable = lib.mkEnableOption "Fastfetch.";
      firefox.enable = lib.mkEnableOption "Firefox web browser.";
      shell.enable = lib.mkEnableOption "Shell with defaults.";
    };

    desktop = {
      kde.enable = lib.mkOption {
        description = "KDE Plasma with sane defaults.";
        default = osConfig.ar.desktop.kde.enable;
        type = lib.types.bool;
      };
    };

    services = {
      easyeffects = {
        enable = lib.mkEnableOption "EasyEffects user service.";

        preset = lib.mkOption {
          description = "Name of preset to start with.";
          default = "";
          type = lib.types.str;
        };
      };
    };

    theme.enable = lib.mkEnableOption "Gtk, Qt, and application colors.";
  };
}
