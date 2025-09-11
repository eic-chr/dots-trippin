
{
  pkgs,
  ...
}: {
  services.seatd.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "kitty";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
    };
    theme = "gruvbox-dark";
   };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    pyprland
    hyprpicker
    hyprcursor
    hyprlock
    hypridle
    hyprpaper
    hyprsunset
    hyprpolkitagent
    rofi
    waybar
  ];
}
