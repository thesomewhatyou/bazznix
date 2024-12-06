{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "steam-rom-manager";
  version = "2.5.29";

  src = fetchurl {
    hash = "sha256-6ZJ+MGIgr2osuQuqD6N9NnPiJFNq/HW6ivG8tyXUhvs=";
    url = "https://github.com/SteamGridDB/steam-rom-manager/releases/download/v${version}/Steam-ROM-Manager-${version}.AppImage";
  };

  extraInstallCommands = let
    appimageContents = appimageTools.extractType2 {
      inherit pname version src;
    };
  in ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png \
      $out/share/icons/hicolor/scalable/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "The bulk game importer and artwork manager for Steam.";
    homepage = "https://github.com/SteamGridDB/steam-rom-manager";
    license = licenses.gpl3Plus;
    mainProgram = "steam-rom-manager";
    platforms = platforms.linux;
  };
}
