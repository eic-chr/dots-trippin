# KDE Plasma Settings
# FIXME: integration of plasma-manager currentlyy not working :(
{ pkgs, ...}:
{
  imports = [
    <plasma-manager/modules>
  ];

  programs = {
    plasma = {
      enable = true;
#
# Some high-level settings:
#
      workspace = {
        clickItemTo = "select";
        lookAndFeel = "org.kde.breezedark.desktop";
        cursorTheme = "Bibata-Modern-Ice";
        iconTheme = "Papirus-Dark";
        # wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
      };
# etc.
    };
  };
}
