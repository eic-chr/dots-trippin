  home-manager.users.charolotte = {

    home.file = {
      "signature-ewolutions-ca.txt" = {
        text = ''
          __________________________________________________________

          EWolutions - Eickhoff & Wölfing IT Solutions GbR

          Einöd 395
          D-98663 Heldburg

          Telefon:   036 871 / 318 625
          E-Mail:  charolotte@ewolutions.de
          __________________________________________________________

          Bitte denken Sie an die Umwelt, bevor Sie diese Mail ausdrucken.
          '';
      };
    };
# /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "24.11";

    home.packages = [
      pkgs.cifs-utils
        pkgs.kdePackages.merkuro
        pkgs.kdePackages.kolourpaint
        pkgs.kdePackages.kdegraphics-thumbnailers
        pkgs.kdePackages.kio-extras
        pkgs.kdePackages.qtimageformats
        pkgs.keepassxc
        pkgs.libreoffice
        pkgs.nextcloud-client
        pkgs.python3
        pkgs.python311Packages.pip
        pkgs.signal-desktop
        pkgs.xorg.xset
        pkgs.git
        ];


    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    programs.home-manager.enable = true;
 
