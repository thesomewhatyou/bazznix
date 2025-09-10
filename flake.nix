{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Core dependencies
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    wallpapers = {
      url = "github:alyraffauf/wallpapers";
      flake = false;
    };
    
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = { self, nixpkgs, home-manager, agenix, disko, lanzaboote, jovian, stylix, wallpapers, chaotic, ... }: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # Formatter for nix fmt
    formatter.${system} = pkgs.alejandra;
    
    # Custom packages
    packages.${system} = {
      adjustor = pkgs.callPackage ./pkgs/adjustor.nix {};
      emudeck = pkgs.callPackage ./pkgs/emudeck.nix {};
      steam-rom-manager = pkgs.callPackage ./pkgs/steam-rom-manager.nix {};
      clean-install = pkgs.writeScriptBin "clean-install" (builtins.readFile ./flake/clean-install.sh);
    };
    
    # Overlays
    overlays.default = import ./overlays/default.nix {inherit self;};
    
    # Home Manager modules
    homeManagerModules = {
      aly = import ./homes/aly self;
    };
    
    # NixOS modules
    nixosModules = import ./nixosModules self;
    
    # NixOS configurations
    nixosConfigurations = {
      pacifidlog = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/pacifidlog
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          stylix.nixosModules.stylix
          self.nixosModules.default
        ];
        specialArgs = { 
          inherit self;
          inherit agenix;
          inherit disko;
          inherit jovian;
          inherit stylix;
          inherit wallpapers;
        };
      };
      
      installer = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          {
            # Basic installer configuration
            nixpkgs.config.allowUnfree = true;
            
            # Add useful packages to the installer
            environment.systemPackages = with pkgs; [
              git
              curl
              wget
              vim
              nano
            ];
            
            # Enable SSH for remote installation
            services.openssh = {
              enable = true;
              settings.PermitRootLogin = "yes";
            };
            
            # Set a default password for the installer
            users.users.nixos.password = "nixos";
            users.users.root.password = "nixos";
          }
        ];
        specialArgs = { inherit self; };
      };
    };
  };
}