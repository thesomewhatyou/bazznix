{
  lib,
  osConfig,
  ...
}: {
  options.steamed-nix.home = {
    apps = {
      fastfetch.enable = lib.mkEnableOption "Fastfetch.";
      shell.enable = lib.mkEnableOption "Shell with defaults.";
    };

    desktop = {
      kde.enable = lib.mkOption {
        description = "KDE Plasma with sane defaults.";
        default = osConfig.steamed-nix.desktop.kde.enable;
        type = lib.types.bool;
      };
    };

    theme.enable = lib.mkEnableOption "Gtk, Qt, and application colors.";
  };
}
