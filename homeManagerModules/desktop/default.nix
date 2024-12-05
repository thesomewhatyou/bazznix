{
  config,
  lib,
  self,
  ...
}: {
  imports = [
    ./kde
  ];

  config =
    lib.mkIf (
      config.ar.home.desktop.kde.enable
    ) {
      dconf = {
        enable = true;
        settings = {
          "org/gnome/desktop/wm/preferences".button-layout =
            if config.ar.home.desktop.kde.enable
            then "appmenu:minimize,maximize,close"
            else "appmenu:close";

          "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
          "org/gtk/settings/file-chooser".sort-directories-first = true;
        };
      };

      gtk.gtk3.bookmarks = [
        "file://${config.xdg.userDirs.documents}"
        "file://${config.xdg.userDirs.download}"
        "file://${config.xdg.userDirs.music}"
        "file://${config.xdg.userDirs.videos}"
        "file://${config.xdg.userDirs.pictures}"
      ];

      xdg = {
        dataFile."backgrounds".source = self.inputs.wallpapers;

        userDirs = {
          enable = true;
          createDirectories = true;
          desktop = lib.mkDefault "${config.home.homeDirectory}/dsktp";
          documents = lib.mkDefault "${config.home.homeDirectory}/docs";
          download = lib.mkDefault "${config.home.homeDirectory}/dwnlds";
          music = lib.mkDefault "${config.home.homeDirectory}/music";
          pictures = lib.mkDefault "${config.home.homeDirectory}/pics";
          publicShare = lib.mkDefault "${config.home.homeDirectory}/pub";
          templates = lib.mkDefault "${config.home.homeDirectory}/tmplts";
          videos = lib.mkDefault "${config.home.homeDirectory}/vids";
        };
      };
    };
}
