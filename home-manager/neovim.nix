{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.lazyvim-nix.homeManagerModules.default
  ];

  programs.lazyvim = {
    enable = true;

    # add extra packages here if a plugin needs them
    extraPackages = with pkgs; [
      ripgrep
      fd
    ];
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
  };

  xdg.configFile."nvim/lua" = {
    source = ./nvim/lua;
    recursive = true;
  };
}
