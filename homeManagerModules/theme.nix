{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.steamed-nix.home;
in {
  config = lib.mkIf cfg.theme.enable {
    stylix = {
      iconTheme = {
        enable = true;
        dark = "Papirus-Dark";
        light = "Papirus";
        package = pkgs.papirus-icon-theme.override {color = "adwaita";};
      };
    };
  };
}
