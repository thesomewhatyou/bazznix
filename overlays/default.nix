# Default overlay.
{self}: final: prev: {
  adjustor = self.packages.${prev.system}.adjustor;
  emudeck = self.packages.${prev.system}.emudeck;
  steam-rom-manager = self.packages.${prev.system}.steam-rom-manager;
}
