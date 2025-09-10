{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Core inputs from flake.lock
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    stylix.url = "github:danth/stylix";
    
    wallpapers = {
      url = "github:alyraffauf/wallpapers";
      flake = false;
    };
  };

  outputs = { 
    self, 
    nixpkgs, 
    agenix,
    chaotic,
    disko, 
    home-manager, 
    jovian,
    lanzaboote,
    stylix,
    wallpapers,
    ... 
  }: {
    nixosModules = {
      default = import ./nixosModules self;
      common-mauville-share = ./common/samba.nix;
      common-tailscale = ./common/tailscale.nix;
      common-us-locale = ./common/us-locale.nix;
      common-wifi-profiles = ./common/wifi.nix;
      hw-lenovo-legion-go = ./hwModules/lenovo/legion/go/default.nix;
    };

    overlays.default = import ./overlays/default.nix { inherit self; };

    packages.x86_64-linux = {
      adjustor = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/adjustor.nix {};
      emudeck = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/emudeck.nix {};
      steam-rom-manager = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs/steam-rom-manager.nix {};
      clean-install = nixpkgs.legacyPackages.x86_64-linux.writeShellApplication {
        name = "clean-install";
        text = builtins.readFile ./flake/clean-install.sh;
      };
    };

    nixosConfigurations = {
      pacifidlog = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pacifidlog/default.nix
          home-manager.nixosModules.home-manager
          self.nixosModules.default
        ];
        specialArgs = { 
          inherit self agenix chaotic disko jovian lanzaboote stylix wallpapers; 
        };
      };
      
      installer = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          self.nixosModules.default
          {
            # Minimal installer configuration
            environment.systemPackages = with nixpkgs.legacyPackages.x86_64-linux; [
              git
              vim
              curl
              wget
              self.packages.x86_64-linux.clean-install
            ];
            
            # Enable flakes for installation
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
          }
        ];
        specialArgs = { 
          inherit self agenix chaotic disko jovian lanzaboote stylix wallpapers; 
        };
      };
    };
    
    # Add formatter for nix fmt
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}