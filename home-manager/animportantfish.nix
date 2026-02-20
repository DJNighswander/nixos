{ ... }: {
  home.stateVersion = "24.11";
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./firefox.nix
    ./gpg.nix
    ./hypridle.nix
    ./hyprland-animportantfish.nix
    #./hyprlock.nix
    #./hyprpaper.nix
    ./neovim.nix
    ./rclone.nix
    ./scripts.nix
    ./swaylock.nix
    ./waybar.nix
    ./tmux.nix
    ./udiskie.nix
  ];

  # Automatically (re)star/stop services when activating a home-manager configuration
  #systemd.user.startServices = true;
}

