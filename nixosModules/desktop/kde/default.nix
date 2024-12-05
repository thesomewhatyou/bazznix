{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.steamed-nix.desktop.kde.enable {
    environment = {
      plasma6.excludePackages = lib.attrsets.attrValues {
        inherit
          (pkgs.kdePackages)
          elisa
          gwenview
          krdp
          okular
          oxygen
          ;
      };

      systemPackages = with pkgs; [maliit-keyboard];
    };

    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org.maliit.keyboard.maliit" = {
            key-press-haptic-feedback = true;
            theme = "BreezeDark";
          };
        };
      }
    ];

    services.desktopManager.plasma6.enable = true;
  };
}
