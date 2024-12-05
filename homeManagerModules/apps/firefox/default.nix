{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.ar.home.apps.firefox.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
