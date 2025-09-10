{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Based on your logs, you have many other inputs (stylix, chaotic-cx, etc.).
    # They should all be declared here.
    # ... other inputs like stylix
  };

  # Using '@inputs' captures all inputs into a single argument.
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # --- FIX: Export your shared modules ---
    # This `nixosModules` output was missing. It fixes the "attribute 'nixosModules' missing"
    # error by making your shared modules available to your hosts via `self.nixosModules.*`.
    nixosModules = {
      # These paths are assumed based on your error log.
      # Please adjust them if your files are in a different directory.
      common-mauville-share = ./nixosModules/common-mauville-share.nix;
      common-tailscale = ./nixosModules/common-tailscale.nix;
    };

    nixosConfigurations = {
      pacifidlog = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # Your host configuration, which likely imports the shared modules using `self`.
          # e.g., ./hosts/pacifidlog/default.nix or configuration.nix
          ./hosts/pacifidlog/configuration.nix

          # This line, which you added, correctly fixes the "option `home-manager' does not exist" error.
          home-manager.nixosModules.home-manager
        ];

        # Passing all inputs via specialArgs is a robust pattern that makes them
        # available to all modules in this host configuration.
        specialArgs = { inherit inputs; };
      };
      # ... other host configurations can go here
    };
  };
}
