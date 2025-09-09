{
  description = "Aly's NixOS flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };

    chaotic = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    };

    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/lanzaboote/v0.4.1";
    };

    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix/master";
    };

    wallpapers = {
      url = "github:alyraffauf/wallpapers";
      flake = false; # This is important to specify that it's a non-flake
    };
  };

  nixConfig = {
    accept-flake-config = true;

    extra-substituters = [
      "https://bazznix.cachix.org"
      "https://alyraffauf.cachix.org"
      "https://chaotic-nyx.cachix.org/"
      "https://jovian-nixos.cachix.org"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
      "bazznix.cachix.org-1:DbV2pJFAzHipBYsfr3csAHaIKRMZ8+XTJJ/ljglBU14="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
      "jovian-nixos.cachix.org-1:mAWLjAxLNlfxAnozUjOqGj4AxQwCl7MXwOfu7msVlAo="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = {self, ...}: let
    allLinuxSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    allMacSystems = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    allSystems = allLinuxSystems ++ allMacSystems;

    forAllLinuxSystems = f:
      self.inputs.nixpkgs.lib.genAttrs allLinuxSystems (system:
        f {
          pkgs = import self.inputs.nixpkgs {inherit system;};
        });

    forAllSystems = f:
      self.inputs.nixpkgs.lib.genAttrs allSystems (system:
        f {
          pkgs = import self.inputs.nixpkgs {inherit system;};
        });

    forAllHosts = self.inputs.nixpkgs.lib.genAttrs [
      "pacifidlog"
    ];
  in {
    devShells = forAllLinuxSystems ({pkgs}: {
      default = pkgs.mkShell {
        packages =
          (with pkgs; [
            e2fsprogs
            git
            mdformat
            nh
            nix-update
            sbctl
          ])
          ++ [
            self.formatter.${pkgs.system}
            self.inputs.agenix.packages.${pkgs.system}.default
            self.packages.${pkgs.system}.default
          ];

        shellHook = ''
          export FLAKE="."
        '';
      };
    });

    formatter = forAllSystems ({pkgs}: pkgs.alejandra);

    homeManagerModules = {
      aly = import ./homes/aly self;
    };

    nixosModules = {
      common-us-locale = import ./common/us-locale.nix;
      common-mauville-share = import ./common/samba.nix;
      common-tailscale = import ./common/tailscale.nix;
      common-wifi-profiles = import ./common/wifi.nix;

      hw-common = import ./hwModules/common;
      hw-common-amd-cpu = import ./hwModules/common/gpu/amd;
      hw-common-amd-gpu = import ./hwModules/common/cpu/amd;
      hw-common-bluetooth = import ./hwModules/common/bluetooth;
      hw-common-gaming = import ./hwModules/common/gaming;
      hw-common-intel-cpu = import ./hwModules/common/cpu/intel;
      hw-common-intel-gpu = import ./hwModules/common/gpu/intel;
      hw-common-laptop = import ./hwModules/common/laptop;
      hw-common-laptop-intel-cpu = import ./hwModules/common/laptop/intel-cpu.nix;
      hw-common-ssd = import ./hwModules/common/ssd;

      hw-asus-tuf-a16-amd-7030 = import ./hwModules/asus/tuf/a16/amd-7030/default.nix;
      hw-framework-13-amd-7000 = import ./hwModules/framework/13/amd-7000;
      hw-framework-13-intel-11th = import ./hwModules/framework/13/intel-11th;
      hw-lenovo-legion-go = import ./hwModules/lenovo/legion/go;

      nixos = import ./nixosModules self;
      users = import ./userModules self;
    };

    nixosConfigurations = forAllHosts (
      host:
        self.inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit self;};
          modules = [
            ./hosts/${host}
            self.inputs.agenix.nixosModules.default
            self.inputs.chaotic.homeManagerModules.default
            self.inputs.disko.nixosModules.disko
            self.inputs.home-manager.nixosModules.home-manager
            self.inputs.lanzaboote.nixosModules.lanzaboote
            self.inputs.stylix.nixosModules.stylix
            self.nixosModules.nixos
            self.nixosModules.users
            {
              home-manager = {
                backupFileExtension = "backup";
                extraSpecialArgs = {inherit self;};
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ];
        }
    ) // {
      # ISO installer configuration
      installer = self.inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit self;};
        modules = [
          "${self.inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          self.nixosModules.nixos
          {
            # Add bazznix modules to the installer
            isoImage.isoName = "bazznix-installer.iso";
            
            # Enable basic gaming and handheld support in the installer
            environment.systemPackages = with self.inputs.nixpkgs.legacyPackages.x86_64-linux; [
              git
              vim
              curl
              wget
            ];
            
            # Include basic hardware support
            hardware.enableAllFirmware = true;
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };

    overlays = {
      default = import ./overlays/default.nix {inherit self;};
    };

    packages = forAllLinuxSystems ({pkgs}: rec {
      default = clean-install;

      adjustor = pkgs.callPackage ./pkgs/adjustor.nix {};

      clean-install = pkgs.writeShellApplication {
        name = "clean-install";
        text = ./flake/clean-install.sh;
      };

      emudeck = pkgs.callPackage ./pkgs/emudeck.nix {};
      steam-rom-manager = pkgs.callPackage ./pkgs/steam-rom-manager.nix {};
    });
  };
}
