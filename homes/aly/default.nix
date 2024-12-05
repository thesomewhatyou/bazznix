self: {pkgs, ...}: {
  imports = [
    ./firefox
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
      vesktop
    ];

    stateVersion = "24.11";
    username = "aly";
  };

  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;

      extensions = [
        {id = "dnhpnfgdlenaccegplpojghhmaamnnfp";} # augmented steam
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "ocabkmapohekeifbkoelpmppmfbcibna";} # zoom redirector
      ];
    };

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
}
