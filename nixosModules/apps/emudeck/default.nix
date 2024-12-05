{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.steamed-nix.apps.emudeck.enable) {
    environment.systemPackages = with pkgs; [emudeck];

    steamed-nix = {
      apps.steam.enable = lib.mkDefault true;
      services.flatpak.enable = lib.mkDefault true;
    };
  };
}
