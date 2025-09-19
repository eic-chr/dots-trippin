{
  description = "Multi-system Nix configuration for macOS, NixOS VM, and laptop";
  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out https://github.com/ryan4yin/nixos-and-flakes-book !
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    substituters = [
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    # Use different nixpkgs for different systems
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # Unstable für einzelne Pakete
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager for user configuration management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NUR for additional packages (Firefox addons)
    nur = {
      url = "github:nix-community/NUR";
    };
    # plasma-manager for KDE Plasma configuration
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Hyprland (for plugin compatibility pinning)
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-dots = {
      url = "github:JaKooLit/Hyprland-Dots";
      flake = false;
    };

    # nix-darwin for macOS
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    # nixos-hardware for device-specific modules
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-darwin,
    darwin,
    home-manager,
    plasma-manager,
    nixos-hardware,
    ...
  }: let
    # Host-zu-User Zuordnung
    hostUsers = {
      MacBookPro = ["christianeickhoff"];
      devnix = ["christian"];
      offnix = ["christian" "charly"];
      playnix = ["christian" "vincent" "victoria"];
    };

    # User-spezifische Konfigurationen
    userConfigs = {
      christianeickhoff = {
        email = "christian@ewolutions.de";
        fullName = "Christian Eickhoff";
        homeConfig = ./home;
        profile = "developer";
        isAdmin = true;
      };
      christian = {
        email = "christian@ewolutions.de";
        fullName = "Christian Eickhoff";
        homeConfig = ./home/nixos.nix;
        profile = "developer";
        isAdmin = true;
      };
      charly = {
        email = "charlotte@ewolutions.de";
        fullName = "Charlotte Amend";
        homeConfig = ./home/charly.nix;
        profile = "office";
        isAdmin = false;
      };
      vincent = {
        email = "vincent@example.com";
        fullName = "Vincent Eickhoff";
        homeConfig = ./home/vincent.nix;
        profile = "developer";
        isAdmin = true;
      };
      victoria = {
        email = "victoria@example.com";
        fullName = "Victoria Eickhoff";
        homeConfig = ./home/victoria.nix;
        profile = "office";
        isAdmin = false;
      };
    };

    # User mapping für Home-Manager Konfigurationen (abgeleitet)
    userHomeConfigs = builtins.mapAttrs (user: config: config.homeConfig) userConfigs;

    # System-specific configurations
    systems = {
      # macOS configuration
      mac = {
        system = "aarch64-darwin";
        hostname = "MacBookPro";
        nixpkgs = nixpkgs-darwin;
        users = hostUsers.MacBookPro;
        hasPlasma = false;
      };

      # NixOS VM configuration
      devnix = {
        system = "x86_64-linux";
        hostname = "devnix";
        nixpkgs = nixpkgs;
        users = hostUsers.devnix;
        hasPlasma = true;
      };

      # Laptop configuration with multiple users
      offnix = {
        system = "x86_64-linux";
        hostname = "offnix";
        nixpkgs = nixpkgs;
        users = hostUsers.offnix;
        hasPlasma = true;
      };

      # Gaming laptop configuration with multiple users
      playnix = {
        system = "x86_64-linux";
        hostname = "playnix";
        nixpkgs = nixpkgs;
        users = hostUsers.playnix;
        hasPlasma = true;
      };
    };

    # Helper function to create specialArgs for each system
    mkSpecialArgs = systemConfig:
      inputs
      // {
        inherit (systemConfig) hostname hasPlasma users;
        inherit userConfigs hostUsers;

        # nixpkgs-unstable importieren und durchreichen
        unstable = import inputs.nixpkgs-unstable {
          system = systemConfig.system;
        };

        # Hyprland / plugins through specialArgs for HM modules
        hyprlandInput = inputs.hyprland;
        hyprlandPlugins = inputs.hyprland-plugins;
        hyprlandPluginsPkgs = inputs.hyprland-plugins.packages.${systemConfig.system};
        hyprlandDots = inputs.hyprland-dots;
        hyprlandDotsLocal = let
          p = ./vendor/hyprland-dots;
        in
          if builtins.pathExists p
          then p
          else null;

        # Für Kompatibilität mit bestehenden Modulen
        username = builtins.head systemConfig.users; # Erster User als Standard
      };

    # Helper function to create home-manager user configurations
    mkHomeManagerUsers = systemConfig:
      builtins.listToAttrs (map (user: {
          name = user;
          value = {
            config,
            lib,
            pkgs,
            unstable,
            ...
          }: {
            imports = [
              (
                if builtins.hasAttr user userConfigs
                then userConfigs.${user}.homeConfig
                else
                  # Fallback: verwende eine Standard-Konfiguration
                  ./home/nixos.nix
              )
            ];

            # User-spezifische Variablen verfügbar machen
            _module.args = {
              currentUser = user;
              userConfig = userConfigs.${user} or {};
              userEmail = userConfigs.${user}.email or "default@example.com";
              userFullName = userConfigs.${user}.fullName or user;
            };
          };
        })
        systemConfig.users);
  in {
    # macOS configuration
    darwinConfigurations."${systems.mac.hostname}" = darwin.lib.darwinSystem {
      system = systems.mac.system;
      specialArgs = mkSpecialArgs systems.mac;
      modules = [
        ./modules/nix-core.nix
        ./modules/system.nix
        ./modules/apps.nix
        ./modules/host-users.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = mkSpecialArgs systems.mac;
          home-manager.users = mkHomeManagerUsers systems.mac;
        }
      ];
    };

    # NixOS configurations
    nixosConfigurations."${systems.devnix.hostname}" = nixpkgs.lib.nixosSystem {
      system = systems.devnix.system;
      specialArgs = mkSpecialArgs systems.devnix;
      modules = [
        ./hosts/devnix/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = mkSpecialArgs systems.devnix;
          home-manager.users = mkHomeManagerUsers systems.devnix;
          home-manager.sharedModules = [
            plasma-manager.homeManagerModules.plasma-manager
          ];
        }
      ];
    };

    nixosConfigurations."${systems.offnix.hostname}" = nixpkgs.lib.nixosSystem {
      system = systems.offnix.system;
      specialArgs = mkSpecialArgs systems.offnix;
      modules = [
        nixos-hardware.nixosModules."apple-macbook-pro-11-4"
        ./hosts/offnix/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = mkSpecialArgs systems.offnix;
          home-manager.users = mkHomeManagerUsers systems.offnix;
          home-manager.sharedModules = [
            plasma-manager.homeManagerModules.plasma-manager
          ];
        }
      ];
    };

    nixosConfigurations."${systems.playnix.hostname}" = nixpkgs.lib.nixosSystem {
      system = systems.playnix.system;
      specialArgs = mkSpecialArgs systems.playnix;
      modules = [
        ./hosts/playnix/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = mkSpecialArgs systems.playnix;
          home-manager.users = mkHomeManagerUsers systems.playnix;
          home-manager.sharedModules = [
            plasma-manager.homeManagerModules.plasma-manager
          ];
        }
      ];
    };

    # Formatters for all systems
    formatter = builtins.listToAttrs (map (
      systemName: let
        systemConfig = systems.${systemName};
      in {
        name = systemConfig.system;
        value = systemConfig.nixpkgs.legacyPackages.${systemConfig.system}.alejandra;
      }
    ) (builtins.attrNames systems));
  };
}
