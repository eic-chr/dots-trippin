
{ ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    ../base
    ./base
    #
    # ========== Host-specific Optional Configs ==========
    #

    ./optional/plasma/base.nix
    ./optional/development
    #common/optional/desktops
  ];

}
