# Default overlay.
{self}: final: prev: {
  adjustor = self.packages.${prev.system}.adjustor;
  hhd-ui = self.packages.${prev.system}.hhd-ui;
  emudeck = self.packages.${prev.system}.emudeck;
  steam-rom-manager = self.packages.${prev.system}.steam-rom-manager;

  brave = prev.brave.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};

  obsidian = prev.obsidian.overrideAttrs (old: {
    installPhase =
      builtins.replaceStrings ["--ozone-platform=wayland"]
      ["--ozone-platform=wayland --enable-wayland-ime"]
      old.installPhase;
  });

  vscodium = prev.vscodium.override {commandLineArgs = "--enable-wayland-ime";};

  webcord = prev.webcord.overrideAttrs (old: {
    installPhase =
      builtins.replaceStrings ["--ozone-platform-hint=auto"]
      ["--ozone-platform-hint=auto --enable-wayland-ime"]
      old.installPhase;
  });
}
