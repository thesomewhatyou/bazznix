{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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
      # Common hardware modules
      hw-common = import ./hwModules/common/default.nix;
      hw-common-amd-cpu = import ./hwModules/common/cpu/amd/default.nix;
      hw-common-amd-gpu = import ./hwModules/common/gpu/amd/default.nix;
      hw-common-intel-cpu = import ./hwModules/common/cpu/intel/default.nix;
      hw-common-intel-gpu = import ./hwModules/common/gpu/intel/default.nix;
      hw-common-bluetooth = import ./hwModules/common/bluetooth/default.nix;
      hw-common-gaming = import ./hwModules/common/gaming/default.nix;
      hw-common-laptop = import ./hwModules/common/laptop/default.nix;
      hw-common-laptop-intel-cpu = import ./hwModules/common/laptop/intel-cpu.nix;
      hw-common-ssd = import ./hwModules/common/ssd/default.nix;

      # Device-specific hardware modules
      hw-lenovo-legion-go = import ./hwModules/lenovo/legion/go/default.nix;
      hw-framework-13-amd-7000 = import ./hwModules/framework/13/amd-7000/default.nix;
      hw-framework-13-intel-11th = import ./hwModules/framework/13/intel-11th/default.nix;
      hw-asus-tuf-a16-amd-7030 = import ./hwModules/asus/tuf/a16/amd-7030/default.nix;

      # NixOS modules
      default = import ./nixosModules/default.nix self;

      # Common configuration modules (referenced by hosts)
      common-mauville-share = import ./common/samba.nix;
      common-tailscale = import ./common/tailscale.nix;
      common-us-locale = import ./common/us-locale.nix;
      common-wifi-profiles = import ./common/wifi.nix;
    };

    nixosConfigurations = {
      pacifidlog = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pacifidlog/default.nix
          agenix.nixosModules.default
          chaotic.nixosModules.default
          disko.nixosModules.default
          home-manager.nixosModules.home-manager
          jovian.nixosModules.default
          lanzaboote.nixosModules.lanzaboote
          stylix.nixosModules.stylix
          self.nixosModules.default
        ];
        specialArgs = {inherit self;};
      };
    };

    # Expose inputs for use in configurations
    inputs = {
      inherit
        agenix
        chaotic
        disko
        home-manager
        jovian
        lanzaboote
        stylix
        wallpapers
        ;
    };
  };
}