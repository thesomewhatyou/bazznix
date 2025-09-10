{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Core system management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Security and boot management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Gaming and Steam Deck support
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Additional system tools
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    
    # Styling
    stylix.url = "github:danth/stylix";
    wallpapers = {
      url = "github:alyraffauf/wallpapers";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    agenix,
    lanzaboote,
    jovian,
    disko,
    chaotic,
    stylix,
    wallpapers,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Define packages
    packages.${system} = {
      adjustor = pkgs.callPackage ./pkgs/adjustor.nix {};
      emudeck = pkgs.callPackage ./pkgs/emudeck.nix {};
      steam-rom-manager = pkgs.callPackage ./pkgs/steam-rom-manager.nix {};
    };
    
    # Define overlays
    overlays.default = import ./overlays/default.nix {inherit self;};
    
    # Define NixOS configurations
    nixosConfigurations = {
      pacifidlog = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/pacifidlog/default.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          stylix.nixosModules.stylix
          (import ./nixosModules/default.nix self)
        ];
        specialArgs = { 
          inherit self agenix lanzaboote jovian disko chaotic stylix wallpapers; 
        };
      };
      
      installer = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          (import ./nixosModules/default.nix self)
        ];
        specialArgs = { 
          inherit self; 
        };
      };
    };
    
    # Development environment
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        nix-prefetch-git
        age
        ssh-to-age
      ];
    };
  };
}