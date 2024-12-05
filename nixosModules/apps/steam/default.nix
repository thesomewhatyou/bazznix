{
  config,
  lib,
  pkgs,
  ...
}: {
  config =
    lib.mkIf (
      config.steamed-nix.apps.steam.enable
      || config.steamed-nix.desktop.steam.enable
    ) {
      hardware.steam-hardware.enable = true;

      programs = {
        gamescope.enable = config.steamed-nix.desktop.steam.enable;

        steam = {
          enable = true;
          dedicatedServer.openFirewall = true;
          extest.enable = true;
          extraCompatPackages = with pkgs; [proton-ge-bin];
          gamescopeSession.enable = config.steamed-nix.desktop.steam.enable;
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
        };
      };
    };
}
