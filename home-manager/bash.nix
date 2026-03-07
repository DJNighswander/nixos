{ ... }: {
  home.file = {
    "/home/djnighs/.bash_aliases" = {
      text = ''
        # enable color support of ls, grep and ip, also add handy aliases
        if [[ -x /usr/bin/dircolors ]]; then
          test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
              alias ls='ls --color=auto'
          alias grep='grep --color=auto'
          alias diff='diff --color=auto'
          alias ip='ip -color'
        fi
        # NixOS specific commands
        nix-search() {
          nix search nixpkgs $1 | less
        }
      '';
    };
    "/home/djnighs/.bash_profile" = {
      text = ''
        if [ -f ~/.bashrc ]; then
          . ~/.bashrc;
        fi
      '';
    };
    "/home/djnighs/.bashrc" = {
      text = ''
        #### Global variables #################
        
        # Default editor
        editor="nvim"
        
        #### Environment variables ############
        
        # `grep default` highlight color
        export GREP_COLOR="1;32"
        
        # Colored man
        export MANPAGER="less -R --use-color -Dd+g -Du+b"
        
        # EDITOR
        export EDITOR=$editor
        export SUDO_EDITOR=$editor
        export VISUAL="nvim"

	# NixOS
	export NIXOS_DIR=/home/djnighs/nixos
        
        
        #### History settings #################
        
        # append to the history file, don't overwrite it
        shopt -s histappend
        
        # load results of history substitution into the readline editing buffer
        shopt -s histverify
        
        # don't put duplicate lines or lines starting with space in the history
        HISTCONTROL=ignoreboth
        
        # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
        HISTSIZE=-1
        HISTFILESIZE=-1
        
        #### Autocompletion ###################
        
        bind 'TAB: menu-complete'
	bind '"\e[Z": menu-complete-backward'
	bind 'Control-Escape: complete'
	


        # necessary for programmable completion
        shopt -s extglob
        
        # cd when entering just a path
        shopt -s autocd
        
        #### Prompt ###########################
        
        PS1='\[\033[0;34m\]┌──(\[\033[1;37m\]djnighs\[\033[0;34m\]\[\033[0;37m\]\h\[\033[0;34m\])-[\[\033[0;36m\]\w\[\033[0;34m\]]
\[\033[0;34m\]└─\[\033[1;37m\]\$\[\033[0m\] '
        
        if [ -f ~/.bash_aliases ]; then
          . .bash_aliases
        fi

        if [ -f /run/secrets/openrouter_key ]; then
          export OPENROUTER_API_KEY=$(cat /run/secrets/openrouter_key);
        fi

       
        if command -v tmux &> /dev/null; then
          tmux new -A -s djnighs
        fi
        
        #### Display ########################
        
        echo -e "\e[0;37m"
        clear
        echo '███╗   ██╗██╗██╗  ██╗ ██████╗ ███████╗'
        echo '████╗  ██║██║╚██╗██╔╝██╔═══██╗██╔════╝'
        echo '██╔██╗ ██║██║ ╚███╔╝ ██║   ██║███████╗'
        echo '██║╚██╗██║██║ ██╔██╗ ██║   ██║╚════██║'
        echo '██║ ╚████║██║██╔╝ ██╗╚██████╔╝███████║'
        echo '╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝'
      '';
    };
  };
}
