.PHONY: help devnix offnix switch-devnix switch-offnix build-devnix build-offnix update clean

help:
	@echo "Available targets:"
	@echo "  devnix        - Build and switch to devnix configuration"
	@echo "  offnix        - Build and switch to offnix configuration"
	@echo "  switch-devnix - Switch to devnix configuration"
	@echo "  switch-offnix - Switch to offnix configuration"
	@echo "  build-devnix  - Build devnix configuration without switching"
	@echo "  build-offnix  - Build offnix configuration without switching"
	@echo "  update        - Update flake inputs"
	@echo "  clean         - Clean old generations"

devnix: switch-devnix

offnix: switch-offnix

switch-devnix:
	doas nixos-rebuild switch --flake .#devnix

switch-offnix:
	doas nixos-rebuild switch --flake .#offnix

build-devnix:
	nixos-rebuild build --flake .#devnix

build-offnix:
	nixos-rebuild build --flake .#offnix

update:
	nix flake update

clean:
	doas nix-collect-garbage -d
	nix-collect-garbage -d