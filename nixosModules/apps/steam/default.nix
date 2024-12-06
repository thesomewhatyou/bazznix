{
  config,
  lib,
  pkgs,
  ...
}: {
  config =
    lib.mkIf (
      config.bazznix.apps.steam.enable
      || config.bazznix.desktop.steam.enable
    ) {
      hardware.steam-hardware.enable = true;

      programs = {
        gamescope.enable = config.bazznix.desktop.steam.enable;

        steam = {
          enable = true;
          dedicatedServer.openFirewall = true;
          extest.enable = true;
          extraCompatPackages = with pkgs; [proton-ge-bin];
          gamescopeSession.enable = config.bazznix.desktop.steam.enable;
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
        };
      };
    };
}
