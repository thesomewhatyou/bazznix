{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home Manager input
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Agenix for secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Disko for disk management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Lanzaboote for secure boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Stylix for system theming
    stylix = {
      url = "github:danth/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Jovian for SteamOS-like experience
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Wallpapers
    wallpapers = {
      url = "github:alyraffauf/wallpapers";
      flake = false;
    };
    
    # Chaotic nyx for additional packages
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix, disko, lanzaboote, stylix, jovian, wallpapers, chaotic, ... }: let
    systems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Overlays
    overlays.default = import ./overlays/default.nix { inherit self; };
    
    # Packages
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      adjustor = pkgs.callPackage ./pkgs/adjustor.nix {};
      emudeck = pkgs.callPackage ./pkgs/emudeck.nix {};
      steam-rom-manager = pkgs.callPackage ./pkgs/steam-rom-manager.nix {};
      clean-install = pkgs.writeShellScriptBin "clean-install" (builtins.readFile ./flake/clean-install.sh);
    });
    
    # NixOS Modules
    nixosModules = {
      # Common modules
      common-mauville-share = ./common/samba.nix;
      common-tailscale = ./common/tailscale.nix;
      common-us-locale = ./common/us-locale.nix;
      common-wifi-profiles = ./common/wifi.nix;
      
      # Hardware modules
      hw-lenovo-legion-go = ./hwModules/lenovo/legion/go/default.nix;
      
      # Main bazznix module
      default = ./nixosModules/default.nix;
    };
    
    # Home Manager Modules
    homeManagerModules = {
      aly = ./homes/aly/default.nix;
    };
    
    # User Modules
    userModules = import ./userModules/default.nix;
    
    # NixOS Configurations
    nixosConfigurations = {
      pacifidlog = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # System modules
          agenix.nixosModules.default
          disko.nixosModules.disko
          lanzaboote.nixosModules.lanzaboote
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          
          # Bazznix modules
          self.nixosModules.default
          
          # Host-specific configuration
          ./hosts/pacifidlog/default.nix
        ];
        specialArgs = { 
          inherit self; 
        };
      };
      
      # Installer ISO
      installer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ./nixosModules/default.nix
          {
            nixpkgs.overlays = [ self.overlays.default ];
            nixpkgs.config.allowUnfree = true;
            
            # Add installation tools
            environment.systemPackages = with nixpkgs.legacyPackages.x86_64-linux; [
              git
              curl
              self.packages.x86_64-linux.clean-install
            ];
            
            # ISO settings
            isoImage.compressImage = true;
            isoImage.squashfsCompression = "gzip -Xcompression-level 1";
          }
        ];
        specialArgs = { inherit self; };
      };
    };
    
    # Formatter
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}