{lib, ...}: {
  options.ar = {
    apps = {
      emudeck.enable = lib.mkEnableOption "EmuDeck emulator manager.";
      firefox.enable = lib.mkEnableOption "Firefox Web Browser.";
      podman.enable = lib.mkEnableOption "Podman for OCI container support.";
      steam.enable = lib.mkEnableOption "Valve's Steam for video games.";
    };

    desktop = {
      kde.enable = lib.mkEnableOption "KDE desktop session.";
      steam.enable = lib.mkEnableOption "Steam + Gamescope session.";
    };

    laptopMode = lib.mkEnableOption "Enable laptop configuration.";

    services.flatpak.enable = lib.mkEnableOption "Flatpak support with GUI.";
  };
}
