self: {pkgs, ...}: {
  imports = [
    ./firefox
    self.homeManagerModules.default
    self.inputs.agenix.homeManagerModules.default
    self.inputs.nur.hmModules.nur
  ];

  home = {
    homeDirectory = "/home/aly";

    packages = with pkgs; [
      curl
      fractal
      nicotine-plus
      obsidian
      tauon
      transmission-remote-gtk
      vesktop
    ];

    stateVersion = "24.11";
    username = "aly";
  };

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Aly Raffauf";
      userEmail = "aly@raffauflabs.com";

      extraConfig = {
        color.ui = true;
        github.user = "alyraffauf";
        push.autoSetupRemote = true;
      };
    };

    home-manager.enable = true;
  };

  systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.

  ar.home = {
    apps = {
      chromium.enable = true;
      fastfetch.enable = true;
      firefox.enable = true;
      shell.enable = true;
    };

    theme.enable = true;
  };
}
