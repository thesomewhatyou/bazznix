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

    theme.enable = lib.mkEnableOption "Gtk, Qt, and application colors.";
  };
}
