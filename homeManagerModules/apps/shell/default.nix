{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.shell.enable {
    home.shellAliases = {
      cat = lib.getExe pkgs.bat;
      grep = lib.getExe config.programs.ripgrep.package;
    };

    programs = {
      direnv.enable = true;

      eza = {
        enable = true;
        extraOptions = ["--group-directories-first" "--header"];
        git = true;
        icons = "auto";
      };

      fzf = {
        enable = true;
        tmux.enableShellIntegration = true;
      };

      oh-my-posh = {
        enable = true;
        useTheme = "zash";
      };

      ripgrep = {
        enable = true;
        arguments = ["--pretty"];
      };

      zellij.enable = true;

      zsh = {
        enable = true;
        autocd = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
        historySubstringSearch.enable = true;

        history = {
          expireDuplicatesFirst = true;
          extended = true;
          ignoreAllDups = true;
        };
      };
    };
  };
}
