{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Add Home Manager input
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # ...other inputs...
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      pacifidlog = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pacifidlog/configuration.nix
          ./hosts/pacifidlog/home.nix
          home-manager.nixosModules.home-manager # <-- Import Home Manager module
        ];
        specialArgs = { inherit self; };
      };
      # ...other hosts...
    };
    # ...other outputs...
  };
}