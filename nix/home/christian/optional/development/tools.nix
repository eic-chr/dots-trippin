
{ pkgs, ... }:
{
  home.packages =
    with pkgs;
  [
    pgadmin4
    zed-editor
    mitmproxy # http/https proxy tool
      wireshark # network analyzer
  ];

}
