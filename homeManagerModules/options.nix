{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  cfg = config.ar.home;
in {
  options.ar.home = {
    apps = {
      chromium = {
        enable = lib.mkEnableOption "Chromium-based browser with default extensions.";
        package = lib.mkPackageOption pkgs "brave" {};
      };

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

    laptopMode = lib.mkOption {
      description = "Enable laptop configuration.";
      default = osConfig.ar.laptopMode;
      type = lib.types.bool;
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
