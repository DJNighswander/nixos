{ config, pkgs, ... }:

{
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
  };
}
