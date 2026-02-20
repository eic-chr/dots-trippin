{
  description = "Dotfiles + NixOS/Home-Manager + stow (root flake)";

  nixConfig = {
    substituters = [
      "https://ncps.lan.eickhoff-it.net"
      # Query the mirror of USTC first, and then the official cache.
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    # Existing infra flake
    infra.url = "path:./nix";
  };

  outputs = {
    self,
    nixpkgs,
    pre-commit-hooks,
    infra,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in
      pkgs.alejandra);

    ########################################
    # pre-commit checks
    ########################################
    checks = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      pre-commit = pre-commit-hooks.lib.${system}.run {
        src = ./.;

        hooks = {
          alejandra.enable = true;
          statix = {
            enable = true;
            name = "statix (changed files)";
            files = "\\.nix$";
            pass_filenames = true;

            entry = ''
              bash -c '
                for file in "$@"; do
                  echo "statix check $file"
                  statix check "$file" || exit 1
                done
              '
            '';
          };
          deadnix = {
            enable = true;
            entry = "deadnix";
            files = "\\.nix$";
          };

          shellcheck.enable = true;
          shfmt.enable = true;

          editorconfig-checker.enable = true;
        };
      };
    });

    ########################################
    # Development shell
    ########################################
    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      default = pkgs.mkShell {
        inputsFrom = [self.checks.${system}.pre-commit];

        packages = with pkgs; [git stow statix deadnix];

        shellHook = ''
          ${self.checks.${system}.pre-commit.shellHook}
          echo "✔ pre-commit hooks installed"
        '';
      };
    });

    ########################################
    # Apps
    ########################################
    apps = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      stow = {
        type = "app";
        program = pkgs.writeShellScript "stow-dotfiles" ''
          set -e
          cd ${self}
          exec ${pkgs.stow}/bin/stow "$@"
        '';
      };
    });

    ########################################
    # Re-export infra outputs
    ########################################
    nixosConfigurations = infra.nixosConfigurations or {};
    homeConfigurations = infra.homeConfigurations or {};
  };
}
