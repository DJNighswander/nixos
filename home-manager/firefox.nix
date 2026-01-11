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
  pkgs,
  lib,
  config,
  inputs,
  self,
  ...
}:
let
  Firefox-custom = pkgs.wrapFirefox pkgs.firefox-unwrapped { };
in
{
  home.sessionVariables.DEFAULT_BROWSER = "${Firefox-custom}/bin/firefox";

  programs.firefox = {
    enable = true;
    profiles.default = {
      userChrome = ''
#TabsToolbar {
  visibility: collapse !important;
}
      '';
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
    package = Firefox-custom;
  };
}
