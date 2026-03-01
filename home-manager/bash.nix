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
        
        # common commands
        alias ..='cd ..'
        alias .2='cd ../..'
        alias .3='cd ../../..'
        alias .4='cd ../../../..'
        alias .5='cd ../../../../..'
        alias lm='ls | more'
        alias ll='ls -lFh'
        alias la='ls -alFh --group-directories-first'
        alias l1='ls -1F --group-directories-first'
        alias l1m='ls -1F --group-directories-first | more'
        alias lh='ls -ld .??*'
        alias lsn='ls | cat -n'
        alias mkdir='mkdir -p -v'
        alias cp='cp --preserve=all'
        alias cpv='cp --preserve=all -v'
        alias cpr='cp --preserve=all -R'
        alias cpp='rsync -ahW --info=progress2'
        alias cs='printf "\033c"'
        alias q='exit'
        alias c='clear'
        alias count='find . -type f | wc -l'
        alias fbig="find . -size +128M -type f -printf '%s %p\n'| sort -nr | head -16"
        alias randir='mkdir -p ./$(cat /dev/urandom | tr -cd 'a-z' | head -c 4)/$(cat /dev/urandom | tr -cd 'a-z' | head -c 4)/'
        
        # memory/CPU
        alias df='df -Tha --total'
        alias free='free -mt'
        alias psa='ps auxf'
        alias cputemp='sensors | grep Core'

	# Run Vieb with Wayland compat
	alias vieb='vieb --force_low_power_gpu --ignore-gpu-blacklist --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,WebContentsForceDark,VaapiVideoDecoder --ozone-platform=wayland'

        
        # Misc
        alias sleep='systemctl suspend'
        alias suspend='systemctl suspend'
        alias hibernate='systemctl hibernate'
        
        # NixOS specific commands
        nix-search() {
          nix search nixpkgs $1 | less
        }
        alias nixos-edit-host='nvim /home/djnighs/nixos/hosts/slaanesh.nix'
        alias nixos-edit='nvim /home/djnighs/nixos/'
        alias nixos-build='sudo nixos-rebuild --flake /home/djnighs/nixos/ switch'


        # neovim wrapper
        alias nvim='/home/djnighs/.scripts/nvim_wrapper.sh'
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
