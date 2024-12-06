{lib, ...}: {
  options.bazznix = {
    enable = lib.mkEnableOption "bazznix with sane defaults.";

    apps = {
      emudeck.enable = lib.mkEnableOption "EmuDeck emulator manager.";
      podman.enable = lib.mkEnableOption "Podman for OCI container support.";
      steam.enable = lib.mkEnableOption "Valve's Steam for video games.";
    };

    desktop = {
      kde.enable = lib.mkEnableOption "KDE desktop session.";
      steam.enable = lib.mkEnableOption "Steam + Gamescope session.";
    };

    shell.enable = lib.mkEnableOption "Customized CLI environment.";

    services.flatpak.enable = lib.mkEnableOption "Flatpak support with GUI.";
  };
}
