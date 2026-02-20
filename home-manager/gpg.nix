{ pkgs, ... }: {
  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true; # Prevents conflicts with pcscd
    };
  };
}

