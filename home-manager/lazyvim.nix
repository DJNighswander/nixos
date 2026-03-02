#{ config, pkgs, ... }:
#
#{
#  nixpkgs.overlays = 
#    let
#      moz-rev = "master";
#      moz-url = builtins.fetchTarball {url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz";};
#      nightlyOverlay = (import "${moz-url}/firefox-overlay.nix");
#    in [
#      nightlyOverlay
#    ];
#  programs.firefox = {
#    enable = true;
#    profiles.default = {
#      userChrome = ''
##TabsToolbar {
#  visibility: collapse !important;
#}
#      '';
#      settings = {
#        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
#      };
#    };
#    package = pkgs.latest.firefox-nightly-bin;
#  };
#}

{
  lazyvim
  self,
  ...
}:
{
  imports = [ lazyvim.homeManagerModules.default ];
  programs.lazyvim.enable = true;
}
