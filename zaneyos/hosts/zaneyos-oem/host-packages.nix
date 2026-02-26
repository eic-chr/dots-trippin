{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    atop
    bottom
    dua
    fd
    gping
    luarocks
    mission-center
    resources
    ncdu
    gdu
    ugrep
    waypaper
  ];
}
