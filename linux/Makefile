PHONY+=all
all: apply 

CHANNELS_ROOT := /nix/var/nix/profiles/per-user/root/channels/
NIXPKGS := /nix/var/nix/profiles/per-user/root/channels/nixos

NIX_CHANNELS=-I nixpkgs=$(CHANNELS_ROOT)nixos
NIX_CHANNELS+=-I home-manager=$(CHANNELS_ROOT)home-manager

PHONY+=apply
apply: configuration.nix
	doas nixos-rebuild switch -I nixos-config=$(abspath $<) $(NIX_CHANNELS)
	# list-executables --clear-cache 2>&1 > /dev/null

PHONY+=update
update: configuration.nix
	doas nixos-rebuild --upgrade-all switch -I nixos-config=$(abspath $<) $(NIX_CHANNELS)
	# list-executables --clear-cache 2>&1 > /dev/null

PHONY+=fix-bl
fix-bl:
	doas nixos-rebuild switch --install-bootloader --flake .#


.PHONY: $(PHONY)
