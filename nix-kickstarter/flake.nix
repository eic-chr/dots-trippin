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
    
    # home-manager for user configuration management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # plasma-manager for KDE Plasma configuration
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    
    # nix-darwin for macOS
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-darwin,
    darwin,
    home-manager,
    plasma-manager,
    ...
  }: let
    # Common user configuration
    usernix = "ce";
    usermac = "christianeickhoff";
    useremail = "christian@ewolutions.de";
    
    # Additional user for offnix
    secondUsernix = "ca";
    
    # System-specific configurations
    systems = {
      # macOS configuration
      mac = {
        system = "aarch64-darwin";
        hostname = "MacBookPro";
        nixpkgs = nixpkgs-darwin;
        users = [usermac];
        hasPlasma = false;
      };
      
      # NixOS VM configuration
      devnix = {
        system = "x86_64-linux";
        hostname = "devnix";
        nixpkgs = nixpkgs;
        users = [usernix];
        hasPlasma = true;
      };
      
      # Laptop configuration with two users
      offnix = {
        system = "x86_64-linux";
        hostname = "offnix";
        nixpkgs = nixpkgs;
        users = [usernix secondUsernix];
        hasPlasma = true;
      };
    };

    # Helper function to create specialArgs for each system
    mkSpecialArgs = systemConfig: 
      inputs // {
        inherit usermac usernix secondUsernix useremail;
        inherit (systemConfig) hostname hasPlasma;
        # Für Kompatibilität mit bestehenden Modulen
        username = if systemConfig.hostname == "MacBookPro" then usermac else usernix;
      };

    # Helper function to create home-manager user configurations
    mkHomeManagerUsers = systemConfig: 
      if systemConfig.hostname == "MacBookPro" then {
        # Für macOS: verwende die bestehende default.nix
        ${usermac} = import ./home;
      } else if systemConfig.hostname == "devnix" then {
        # Für devnix VM: nur ein Benutzer, verwende nixos.nix
        ${usernix} = import ./home/nixos.nix;
      } else {
        # Für offnix: zwei Benutzer, verwende beide existierenden Dateien
        ${usernix} = import ./home/nixos.nix;
        ${secondUsernix} = import ./home/ca.nix;
      };

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

    # Formatters for all systems
    formatter = builtins.listToAttrs (map (systemName: 
      let systemConfig = systems.${systemName}; in {
        name = systemConfig.system;
        value = systemConfig.nixpkgs.legacyPackages.${systemConfig.system}.alejandra;
      }
    ) (builtins.attrNames systems));
  };
}
