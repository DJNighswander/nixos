{ config, pkgs, ... }:

{
  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
    };
  };

  # To link waylock to swayidle
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300; # Lock after 5 minutes of inactivity
        command = "${pkgs.waylock}/bin/swaylock";
      }
    ];
  };
}
