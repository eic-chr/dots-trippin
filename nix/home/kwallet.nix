{ config, lib, pkgs, ... }:

# Home Manager module: D-Bus or systemd user activation for kwalletd6 (e.g., Hyprland)
#
# Usage:
# - Import this module in your HM user config and enable:
#     programs.kwalletd6.enable = true;
# - Optional: use a systemd --user service instead of D-Bus:
#     programs.kwalletd6.activation = "systemd";
#
# Notes:
# - Provides a D-Bus service to start KDE Wallet daemon (kwalletd6) on demand.
# - For passwordless unlock on login, ensure PAM integration is enabled on the system:
#     security.pam.services.login.kwallet.enable = true;
#     security.pam.services.sddm.kwallet.enable = true;
# - No GNOME keyring is required for kwalletd6.
let
  inherit (lib) mkIf mkMerge mkEnableOption mkOption types;
  cfg = config.programs.kwalletd6;
in {
  options.programs.kwalletd6 = {
    enable = mkEnableOption "Enable KDE Wallet daemon (kwalletd6)";

    package = mkOption {
      type = types.package;
      default = pkgs.kdePackages.kwallet;
      description = "Package providing kwalletd6.";
    };

    activation = mkOption {
      type = types.enum [ "dbus" "systemd" ];
      default = "dbus";
      description = "How to start kwalletd6: via D-Bus activation (default) or a systemd --user service.";
      example = "systemd";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Ensure kwalletd6 is available in PATH as well (optional, helpful for debugging)
      home.packages = [ cfg.package ];
    }
    (mkIf (cfg.activation == "dbus") {
      # D-Bus activation: provide org.kde.kwalletd6 service file
      xdg.dataFile."dbus-1/services/org.kde.kwalletd6.service".text = ''
        [D-BUS Service]
        Name=org.kde.kwalletd6
        Exec=${cfg.package}/libexec/kwalletd6
        X-KDE-StartupNotify=false
      '';
    })
    (mkIf (cfg.activation == "systemd") {
      # systemd --user service for kwalletd6
      systemd.user.services.kwalletd6 = {
        Unit = {
          Description = "KDE Wallet Daemon (kwalletd6)";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session-pre.target" "dbus.service" ];
        };
        Service = {
          Type = "dbus";
          BusName = "org.kde.kwalletd6";
          ExecStart = "${cfg.package}/libexec/kwalletd6";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    })
  ]);
}
