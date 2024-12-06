{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.bazznix.shell.enable {
    environment = {
      shellAliases = {
        cat = lib.getExe pkgs.bat;
        grep = lib.getExe pkgs.ripgrep;
        ls = lib.getExe pkgs.eza;
      };

      systemPackages = with pkgs; [
        bat
        eza
        git
        htop
        inxi
        ripgrep
        zellij
      ];
    };

    programs = {
      direnv.enable = true;
      fzf.fuzzyCompletion = true;

      zsh = {
        enable = true;
        autosuggestions.enable = true;
        enableCompletion = true;
        ohMyZsh.theme = "simple";
      };
    };

    users.defaultUserShell = pkgs.zsh;
  };
}
