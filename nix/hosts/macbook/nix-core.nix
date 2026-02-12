_: {
  nix = {
    # Determinate uses its own daemon to manage the Nix installation that
    # conflicts with nix-darwin's native Nix management.
    enable = false;

    # Kommentieren Sie alles andere aus oder entfernen Sie es:
    # package = pkgs.nix;
    settings = {experimental-features = ["nix-command" "flakes"];};
    # gc = { ... };
  };
}
