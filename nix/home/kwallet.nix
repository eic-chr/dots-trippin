{ config, lib, pkgs, ... }:

# Home Manager module: autostart kwalletd6 in user sessions (e.g., Hyprland)
#
# Usage:
# - Import this module in your HM user config and enable:
#     programs.kwalletd6.enable = true;
#
# Notes:
# - This starts the KDE Wallet daemon (kwalletd6) in your user session.
# - For passwordless unlock on login, ensure PAM integration is enabled on the system:
#     security.pam.services.login.enableKwallet = true;
#     security.pam.services.sddm.enableKwallet = true;
# - No GNOME keyring is required for kwalletd6.
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.programs.kwalletd6;
in {
  options.programs.kwalletd6 = {
    enable = mkEnableOption "Autostart KDE Wallet daemon (kwalletd6) in the user session";

    package = mkOption {
      type = types.package;
      default = pkgs.kdePackages.kwallet;
      description = "Package providing kwalletd6.";
    };
  };

  config = mkIf cfg.enable {
    # Ensure kwalletd6 is available in PATH as well (optional, helpful for debugging)
    home.packages = [ cfg.package ];

    # Autostart kwalletd6 for Wayland/Hyprland user sessions
    systemd.user.services.kwalletd6 = {
      Unit = {
        Description = "KDE Wallet Daemon (kwalletd6)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" "dbus.service" ];
      };

      Service = {
        # kwalletd daemons are typically installed under libexec
        ExecStart = "${cfg.package}/libexec/kwalletd6";
        Restart = "on-failure";
        Environment = "XDG_RUNTIME_DIR=%t";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
