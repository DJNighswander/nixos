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
        
        # Start windows and panes at 1, not 0
        set -g base-index 1
        setw -g pane-base-index 1
        
        set-hook -g after-new-session {
            # 1. Setup ".SYST_DEV" window
            # Rename the initial window created by tmux
            rename-window '.SYST_DEV'
            send-keys 'cd /etc/nixos && nvim ./' C-m
            # Split horizontally (top/bottom)
            split-window -v -p 30 -c /etc/nixos
            # The '-p 30' gives the bottom shell 30% of the space; adjust as needed.
            
            # 2. Setup ".RUST_DEV" window
            new-window -n '.RUST_DEV' -c ~/documents/development/entityquest
            send-keys 'nvim ./' C-m
            split-window -v -p 30 -c ~/documents/development/entityquest
            
            # 3. Setup ".USER_CON" window
            new-window -n '.USER_CON'

            set-hook -u after-new-session
        }
	'';
      }
    ];
  };
}
