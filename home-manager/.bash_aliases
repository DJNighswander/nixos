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
