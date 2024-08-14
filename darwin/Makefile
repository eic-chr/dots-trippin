PHONY+=all
all: apply 

CHANNELS_ROOT := $(HOME)/.nix-defexpr/channels/

NIX_CHANNELS=-I nixpkgs=$(CHANNELS_ROOT)nixpkgs
NIX_CHANNELS+=-I home-manager=$(CHANNELS_ROOT)home-manager
NIX_CHANNELS+=-I darwin=$(CHANNELS_ROOT)darwin

PHONY+=update
update:
	brew upgrade
	brew upgrade --cask
	nix-channel --update
	$(MAKE) apply

PHONY+=apply
apply:
	$$(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch -I darwin-config=./default.nix $(NIX_CHANNELS)

.PHONY: $(PHONY)
