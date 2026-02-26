English | [Español](./emacs.nix.cheatsheet.es.md)

# Doom Emacs + Nix Cheatsheet

This guide lists the Nix commands and keybindings configured in your Doom Emacs.

## Requirements
- Doom module enabled: `(nix +tree-sitter +lsp)` in `~/.doom.d/init.el`
- Packages installed (via `~/.doom.d/packages.el`): `nix`, `nix-update`, `nixos-options`
- Nix tooling available on system: `nix`, `nixfmt` (or your preferred formatter)
- Optional but recommended: `nil` (Nix LSP)

## Leader key conventions
- `SPC` = Doom leader
- `SPC m` = Major mode menu (contextual to current buffer, e.g., Nix buffers)

## Nix keybindings
- `SPC m f` → `nix-format-buffer` — Format current Nix buffer (uses `nixfmt` by default)
- `SPC m b` → `nix-build` — Build the current derivation / expression
- `SPC m s` → `nix-shell` — Open a `nix-shell`
- `SPC m u` → `nix-unpack` — Unpack a Nix source
- `SPC m r` → `nix-repl-show` — Show symbol info in Nix REPL
- `SPC m U` → `nix-update-fetch` — Update fetchers/hashes in Nix expressions
- `SPC m o` → `+nix/lookup-option` — Lookup NixOS option (requires `:tools lookup` and `nixos-options`)

## Command reference
- `nix-format-buffer`: Formats the current buffer using `nixfmt`.
  - Configured via `(setq nix-nixfmt-bin "nixfmt")`.
  - Tip: Prefer a different formatter? Install it and set `nix-nixfmt-bin` accordingly (e.g., `"alejandra"` or `"nixpkgs-fmt"`).
- `nix-build`: Triggers a build for the current file/context.
- `nix-shell`: Opens a development shell derived from the current Nix expression.
- `nix-unpack`: Unpacks the source for a derivation (useful to inspect sources).
- `nix-repl-show`: Displays symbol info from a Nix REPL session.
- `nix-update-fetch`: Updates fetcher attributes (rev, sha256, etc.).
- `+nix/lookup-option`: Jumps to documentation for a NixOS option using `nixos-options` integration.

## Tips
- Ensure you are editing a `.nix` file so the `SPC m` (major mode) bindings are available.
- For LSP features (hover docs, completion, diagnostics), make sure the `nil` language server is installed and running.

## Troubleshooting
- Commands not found in Emacs? Run `~/.emacs.d/bin/doom sync`, then restart Emacs.
- Formatter not working? Verify `nixfmt` (or chosen formatter) is on your PATH and `nix-nixfmt-bin` matches its name.
- Option lookup not working? Ensure `nixos-options` is installed and Doom’s `:tools lookup` is enabled.

