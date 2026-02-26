NixOS, flakes, and home-manager all work together to achieve a declarative and
reproducible system configuration. They are part of a paradigm shift away from
traditional, imperative system administration.

## NixOS

**NixOS** is a Linux distribution built on the **Nix package manager**. Unlike
other distros where you manually install and configure software, NixOS uses a
**declarative approach**. You write a single `configuration.nix` file that
describes the entire state of your system, including the kernel, services, and
installed programs. When you "build" and "switch" your configuration, NixOS
creates a new, complete system from scratch.

This is the key to its power: instead of modifying files in place, NixOS creates
a new "generation" of your system. If an update breaks something, you can
instantly and safely **roll back** to a previous working generation.

## Flakes

**Flakes** are an experimental but widely adopted feature for the Nix package
manager that standardizes and improves dependency management. A flake is
essentially a directory with a `flake.nix` file and a corresponding `flake.lock`
file.

- `flake.nix` declares the inputs (e.g., specific versions of Nixpkgs, other
  repositories) and outputs (e.g., your system configuration, development
  environments). This makes all dependencies **explicit**.
- `flake.lock` pins the exact versions of all inputs, including the specific Git
  commit hashes. This ensures that your configuration is **reproducible** down
  to the last byte. No more "it works on my machine" problems because someone
  else has a different package version.

## Home Manager

While NixOS manages system-wide configuration (things in `/etc`), **Home
Manager** is a tool that applies the same declarative principles to your
user-specific configuration (your dotfiles in `~/.config`). It lets you manage
your shell, programs, and other user-level settings with Nix.

Home Manager can be used as a standalone tool or, more commonly, integrated into
your NixOS flake. By using it with flakes, you get the same benefits of
reproducibility and atomic updates for your user environment.

## Why Configurations are Read-Only

The concept of read-only configuration files is central to Nix's design and is
the key to its reproducibility.

NixOS builds configurations in a special, read-only directory called the **Nix
Store** (`/nix/store`). When you rebuild your system, Nix generates a new set of
configuration files and stores them in a new directory within the Nix Store.

Instead of writing directly to a configuration file like `~/.bashrc`, NixOS and
Home Manager create **symbolic links** from the expected location (e.g.,
`~/.bashrc`) to the generated, read-only file in the Nix Store.

This approach guarantees that:

1. **Immutability:** Configuration files can't be changed after they're built,
   preventing manual edits from breaking your system.
2. **Reproducibility:** The same configuration file will always produce the
   exact same result because the source files are immutable.
3. **Atomic Upgrades/Rollbacks:** Because each configuration is a self-contained
   "generation," switching between them is a fast, atomic operation.
