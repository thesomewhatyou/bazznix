{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "hhd-ui";
  version = "3.3.2";

  src = fetchurl {
    hash = "sha256-ax2Wf/yTVPCNJeweWA3QL8GXAx8xNzElZgoWKY9Ktbc=";
    url = "https://github.com/hhd-dev/hhd-ui/releases/download/v${version}/${pname}.AppImage";
  };

  meta = with lib; {
    description = "Graphical user interface for Handheld Daemon settings from Steam Big Picture Mode, the Desktop, and the Web.";
    homepage = "https://github.com/hhd-dev/hhd-ui/";
    license = licenses.gpl3Plus;
    mainProgram = "hhd-ui";
    platforms = platforms.linux;
  };
}
