{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        devnix = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/devnix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.christian = {
                imports = [
                  plasma-manager.homeManagerModules.plasma-manager
                  ./home-manager/users/christian.nix
                ];
                # English locale for devnix
                home.language = {
                  base = "en_US.UTF-8";
                };
                home.sessionVariables = {
                  LANG = "en_US.UTF-8";
                  LC_ALL = "en_US.UTF-8";
                  LC_MESSAGES = "en_US.UTF-8";
                };
                programs.plasma = {
                  enable = true;
                  configFile = {
                    "kdeGlobals" = {
                      "Locale" = {
                        "LANG" = "en_US.UTF-8";
                        "LC_MESSAGES" = "en_US.UTF-8";
                        "Country" = "us";
                        "Language" = "en";
                      };
                      "General" = {
                        "Name" = "Breeze Dark";
                        "ColorScheme" = "BreezeDark";
                      };
                      "KDE" = {
                        "SingleClick" = false;
                        "LookAndFeelPackage" = "org.kde.breezedark.desktop";
                      };
                    };
                  };
                };
              };
            }
          ];
        };

        offnix = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/offnix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users = {
                christian = {
                  imports = [
                    plasma-manager.homeManagerModules.plasma-manager
                    ./home-manager/users/christian.nix
                  ];
                  # German locale for christian on offnix
                  home.language = {
                    base = "de_DE.UTF-8";
                  };
                  home.sessionVariables = {
                    LANG = "de_DE.UTF-8";
                    LC_ALL = "de_DE.UTF-8";
                    LC_MESSAGES = "de_DE.UTF-8";
                  };
                  programs.plasma = {
                    enable = true;
                    configFile = {
                      "kdeGlobals" = {
                        "Locale" = {
                          "LANG" = "de_DE.UTF-8";
                          "LC_MESSAGES" = "de_DE.UTF-8";
                          "Country" = "de";
                          "Language" = "de";
                        };
                        "General" = {
                          "Name" = "Breeze Dark";
                          "ColorScheme" = "BreezeDark";
                        };
                        "KDE" = {
                          "SingleClick" = false;
                          "LookAndFeelPackage" = "org.kde.breezedark.desktop";
                        };
                      };
                    };
                  };
                };
                charlotte = {
                  imports = [
                    plasma-manager.homeManagerModules.plasma-manager
                    ./home-manager/users/charlotte.nix
                  ];
                };
              };
            }
          ];
        };
      };

      # Standalone Home-Manager configurations
      homeConfigurations = {
        "christian@devnix" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            plasma-manager.homeManagerModules.plasma-manager
            ./home-manager/users/christian.nix
            {
              home.username = "christian";
              home.homeDirectory = "/home/christian";
              home.stateVersion = "24.11";

              # English locale for devnix
              home.language = {
                base = "en_US.UTF-8";
              };
              home.sessionVariables = {
                LANG = "en_US.UTF-8";
                LC_ALL = "en_US.UTF-8";
                LC_MESSAGES = "en_US.UTF-8";
              };

              programs.plasma = {
                enable = true;
                configFile = {
                  "kdeGlobals" = {
                    "Locale" = {
                      "LANG" = "en_US.UTF-8";
                      "LC_MESSAGES" = "en_US.UTF-8";
                      "Country" = "us";
                      "Language" = "en";
                    };
                    "General" = {
                      "Name" = "Breeze Dark";
                      "ColorScheme" = "BreezeDark";
                    };
                    "KDE" = {
                      "SingleClick" = false;
                      "LookAndFeelPackage" = "org.kde.breezedark.desktop";
                    };
                  };
                };
              };

              # Add host-specific packages for devnix
              home.packages = with pkgs; [
                docker
                vscode
                zed-editor
                golangci-lint
                gopls
                gofumpt
                gotools
                gomodifytags
                impl
                iferr
                gotests
                delve
              ];
            }
          ];
        };

        "christian@offnix" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            plasma-manager.homeManagerModules.plasma-manager
            ./home-manager/users/christian.nix
            {
              home.username = "christian";
              home.homeDirectory = "/home/christian";
              home.stateVersion = "24.11";

              # German locale for offnix
              home.language = {
                base = "de_DE.UTF-8";
              };
              home.sessionVariables = {
                LANG = "de_DE.UTF-8";
                LC_ALL = "de_DE.UTF-8";
                LC_MESSAGES = "de_DE.UTF-8";
              };

              programs.plasma = {
                enable = true;
                configFile = {
                  "kdeGlobals" = {
                    "Locale" = {
                      "LANG" = "de_DE.UTF-8";
                      "LC_MESSAGES" = "de_DE.UTF-8";
                      "Country" = "de";
                      "Language" = "de";
                    };
                    "General" = {
                      "Name" = "Breeze Dark";
                      "ColorScheme" = "BreezeDark";
                    };
                    "KDE" = {
                      "SingleClick" = false;
                      "LookAndFeelPackage" = "org.kde.breezedark.desktop";
                    };
                  };
                };
              };
            }
          ];
        };

        "charlotte@offnix" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            plasma-manager.homeManagerModules.plasma-manager
            ./home-manager/users/charlotte.nix
            {
              home.username = "charlotte";
              home.homeDirectory = "/home/charlotte";
              home.stateVersion = "24.11";
            }
          ];
        };
      };
    };
}
