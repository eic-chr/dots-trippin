{ lib, userEmail, userFullName, ... }:
let
  pubKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPqqh2xgVQ2w7rznDOMvShWRuEDcm3kwmux5N5lnGux ap4103@MacBookRWRMF4N0G3";
in {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig =
    lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      rm -f ~/.gitconfig
    '';

  programs = {
    delta = {
      enable = true;
      options = { features = "side-by-side"; };
    };
    git = {
      enable = true;
      lfs.enable = true;

      # TODO replace with your own name & email

      includes = [{
        # use diffrent email & name for work
        path = "~/work/.gitconfig";
        condition = "gitdir:~/work/";
      }];

      signing = {
        key = "~/.ssh/id_ed25519";
        signByDefault = true;
      };
      settings = {
        credential.helper = "osxkeychain";
        user.name = userFullName;
        user.email = userEmail;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
        gpg.format = "ssh";

        alias = {
          # common aliases
          br = "branch";
          co = "checkout";
          st = "status";
          ls = ''
            log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'';
          ll = ''
            log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'';
          cm = "commit -m";
          ca = "commit -am";
          dc = "diff --cached";
          amend = "commit --amend -m";

          # aliases for submodule
          update = "submodule update --init --recursive";
          foreach = "submodule foreach";
        };
      };
    };
  };
  home.file.".config/git/allowed_signers".text = ''
    ${userEmail} ${pubKey}
  '';
}
