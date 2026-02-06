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
    substituters = ["https://ncps.lan.eickhoff-it.net" "https://cache.nixos.org"];

    trusted-public-keys = [
      "ncps.lan.eickhoff-it.net-1:kPV9cRk5SA/oqFPzY4lTEWv1/2fs1Q4AaNX2x872rFM="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    connect-timeout = 2;
    fallback = true;
  };

  inputs = {
    # Use different nixpkgs for different systems
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # Unstable für einzelne Pakete
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager for user configuration management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # NUR for additional packages (Firefox addons)
    nur = {url = "github:nix-community/NUR";};
    # plasma-manager for KDE Plasma configuration
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Hyprland (for plugin compatibility pinning)
    hyprland = {url = "github:hyprwm/Hyprland";};
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    ml4w-dotfiles = {
      url = "github:mylinuxforwork/dotfiles";
      flake = false;
    };
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };

    # nix-darwin for macOS
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    # nixos-hardware for device-specific modules
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    # external secrets repo (flake)
    secrets.url =
      # "path:/home/christian/projects/ceickhoff/nix-secrets";
      "git+ssh://git@gitlab.dev.ewolutions.de/eickhoff/nix-secrets.git?ref=feat/first";

    # agenix for secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    agenix,
    secrets,
    split-monitor-workspaces,
    ...
  }: let
    # Host-zu-User Zuordnung
    hostUsers = {
      MacBookPro = ["ap4103"];
      devnix = ["christian"];
      offnix = ["christian" "charly"];
      magnix = ["christian" "victoria"];
      playnix = ["christian" "vincent" "victoria"];
    };

    # User-spezifische Konfigurationen
    userConfigs = {
      ap4103 = {
        email = "christian@ewolutions.de";
        fullName = "Christian Eickhoff";
        homeConfig = ./home/ap4103.nix;
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

    # System-specific configurations
    systems = {
      # macOS configuration
      mac = {
        system = "aarch64-darwin";
        hostname = "MacBookRWRMF4N0G3";
        nixpkgs = nixpkgs-darwin;
        users = hostUsers.MacBookPro;
        hasPlasma = false;
      };

      # NixOS VM configuration
      devnix = {
        system = "x86_64-linux";
        hostname = "devnix";
        inherit nixpkgs;
        users = hostUsers.devnix;
        hasPlasma = true;
      };

      # Laptop configuration with multiple users
      offnix = {
        system = "x86_64-linux";
        hostname = "offnix";
        inherit nixpkgs;
        users = hostUsers.offnix;
        hasPlasma = true;
      };

      magnix = {
        system = "x86_64-linux";
        hostname = "magnix";
        inherit nixpkgs;
        users = hostUsers.magnix;
        hasPlasma = true;
      };

      # Gaming laptop configuration with multiple users
      playnix = {
        system = "x86_64-linux";
        hostname = "playnix";
        inherit nixpkgs;
        users = hostUsers.playnix;
        hasPlasma = true;
      };
    };

    isLinuxSystem = system: builtins.match ".*-linux" system != null;

    # Helper function to create specialArgs for each system
    mkSpecialArgs = systemConfig: let
      isLinux = isLinuxSystem systemConfig.system;

      baseArgs =
        inputs
        // {
          inherit (systemConfig) hostname hasPlasma users;
          inherit userConfigs hostUsers;

          secrets = inputs.secrets.outPath;
          # Für Kompatibilität mit bestehenden Modulen
          username =
            builtins.head systemConfig.users; # Erster User als Standard
        };
      linuxArgs =
        if isLinux
        then {
          # nixpkgs-unstable importieren und durchreichen
          unstable =
            import inputs.nixpkgs-unstable {inherit (systemConfig) system;};
          # Hyprland / plugins through specialArgs for HM modules
          hyprlandInput = inputs.hyprland;
          hyprlandPlugins = inputs.hyprland-plugins;
          hyprlandPluginsPkgs =
            inputs.hyprland-plugins.packages.${systemConfig.system};
          splitMonitorWorkspaces = inputs.split-monitor-workspaces;
          ml4wDots = inputs.ml4w-dotfiles;
        }
        else {};
    in
      baseArgs // linuxArgs;

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
                then
                  builtins.trace
                  "→ User-spezifische Home-Konfiguration wird geladen"
                  userConfigs.${user}.homeConfig
                else
                  builtins.trace "→ Fallback: ./home/nixos.nix wird geladen"
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
      inherit (systems.mac) system;
      specialArgs = mkSpecialArgs systems.mac;
      modules = [
        ./hosts/macbook/nix-core.nix
        ./hosts/macbook/system.nix
        ./hosts/macbook/apps.nix
        ./hosts/macbook/host-users.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users = mkHomeManagerUsers systems.mac;
            extraSpecialArgs = mkSpecialArgs systems.mac;
          };
        }
      ];
    };

    # NixOS configurations
    nixosConfigurations = {
      "${systems.magnix.hostname}" = nixpkgs.lib.nixosSystem {
        inherit (systems.magnix) system;
        specialArgs = mkSpecialArgs systems.magnix;
        modules = [
          ./hosts/magnix/configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = mkSpecialArgs systems.magnix;
              users = mkHomeManagerUsers systems.magnix;
              sharedModules = [plasma-manager.homeManagerModules.plasma-manager];
            };
          }
        ];
      };
      # NixOS configurations
      "${systems.devnix.hostname}" = nixpkgs.lib.nixosSystem {
        inherit (systems.devnix) system;
        specialArgs = mkSpecialArgs systems.devnix;
        modules = [
          ./hosts/devnix/configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = mkSpecialArgs systems.devnix;
              users = mkHomeManagerUsers systems.devnix;
              sharedModules = [plasma-manager.homeManagerModules.plasma-manager];
            };
          }
        ];
      };

      "${systems.offnix.hostname}" = nixpkgs.lib.nixosSystem {
        inherit (systems.offnix) system;
        specialArgs = mkSpecialArgs systems.offnix;
        modules = [
          nixos-hardware.nixosModules."apple-macbook-pro-11-4"
          ./hosts/offnix/configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = mkSpecialArgs systems.offnix;
              users = mkHomeManagerUsers systems.offnix;
              sharedModules = [plasma-manager.homeManagerModules.plasma-manager];
            };
          }
        ];
      };

      "${systems.playnix.hostname}" = nixpkgs.lib.nixosSystem {
        inherit (systems.playnix) system;
        specialArgs = mkSpecialArgs systems.playnix;
        modules = [
          ./hosts/playnix/configuration.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = mkSpecialArgs systems.playnix;
              users = mkHomeManagerUsers systems.playnix;
              sharedModules = [plasma-manager.homeManagerModules.plasma-manager];
            };
          }
        ];
      };
    };

    # Formatters for all systems
    formatter = builtins.listToAttrs (map (systemName: let
      systemConfig = systems.${systemName};
    in {
      name = systemConfig.system;
      value =
        systemConfig.nixpkgs.legacyPackages.${systemConfig.system}.alejandra;
    }) (builtins.attrNames systems));
  };
}
