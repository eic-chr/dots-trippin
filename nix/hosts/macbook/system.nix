_:
###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
###################################################################################
{
  system = {
    stateVersion = 6;

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock

      # other macOS's defaults configuration.
      # ......
    };
  };

  security = {
    pki.certificates = [
      (builtins.readFile ../../assets/HUK-COBURG-TU-RootCA10.cer)
      (builtins.readFile ../../assets/HUK-COBURG-TU-DMZ-SubCA12_2023.cer)
    ];
    # Add ability to used TouchID for sudo authentication
    pam.services.sudo_local.touchIdAuth = true;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  # programs.zsh.enable = true;
}
