{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    historyLimit = 10000;
    terminal = "alacritty";
    keyMode = "vi";
    shortcut = "space";
    plugins = with pkgs.tmuxPlugins; [
      gruvbox {
        plugin = gruvbox;
	extraConfig = ''
        set -g @tmux-gruvbox 'dark'
	'';
      }
    ];
  };
}
