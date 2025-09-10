{
  description = "A flake that provides NixOS configurations, packages, and development shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Ensure all other inputs (stylix, etc.) are declared here.
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # --- FIX 1: Add a formatter for `fmt check` ---
      formatter.${system} = pkgs.nixpkgs-fmt;

      # --- FIX 2: Export shared modules for `pacifidlog` ---
      nixosModules = {
        # ==> ACTION: Adjust these paths if they are incorrect <==
        common-mauville-share = ./nixosModules/common-mauville-share.nix;
        common-tailscale = ./nixosModules/common-tailscale.nix;
      };


      #--- FIX 3: Define packages for `adjustor-build`, `emudeck-build`, etc. ---
      packages.${system} = {
        adjustor = pkgs.callPackage ./pkgs/adjustor.nix { };
        emudeck = pkgs.callPackage ./pkgs/emudeck.nix { };
        "steam-rom-manager" = pkgs.callPackage ./pkgs/steam-rom-manager.nix { };

        # --- ADD THIS LINE ---
        # This defines the missing package and will fix the error.
        "clean-install" = pkgs.callPackage ./pkgs/clean-install.nix { };
      };


      # --- FIX 4 & 5: Define NixOS configurations with correct paths and ISO build ---
      nixosConfigurations = {
        # Configuration for your 'pacifidlog' host
        pacifidlog = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # ==> ACTION: Use the correct path to your host's main configuration file! <==
            # This path was incorrect, causing the "path does not exist" error.
            ./hosts/pacifidlog/default.nix # Or whatever the file is actually named

            # This line fixes the `home-manager` error.
            home-manager.nixosModules.home-manager
          ];
        };

        # Configuration for the ISO build, as expected by your CI
        installer = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # ==> ACTION: Provide the path to your ISO's configuration.nix <==
            ./iso/configuration.nix

            # You might also need home-manager for the installer environment
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
