{ pkgs, ... }: {
  home.file = {
    "/home/djnighs/.scripts/start_once_wrapper.sh" = {
      executable = true;
      source = ./scripts/start_once_wrapper.sh;
    };
    "/home/djnighs/.scripts/switcher.sh" = {
      executable = true;
      source = ./scripts/switcher.sh;
    };
    "/home/djnighs/.scripts/toggle_onscreen_keyboard.sh" = {
      executable = true;
      source = ./scripts/toggle_onscreen_keyboard.sh;
    };
    "/home/djnighs/.scripts/start_btop_background.sh" = {
      executable = true;
      text = ''
        kitten panel --edge=none --layer=background --margin-top=27 -o background_opacity=1. -o background="#282828" btop
      '';
    };
    "/home/djnighs/.config/nwg-wrapper/btop_background.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/bash
        alacritty -T "bg_term" -e btop
      '';
    };
    "/home/djnighs/.scripts/start_tmux.sh" = {
      executable = true;
      text = ''
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux -A -s djnighs
fi
      '';
    };
    "/home/djnighs/.scripts/start_alacritty.sh" = {
      executable = true;
      text = ''
#!/usr/bin/env bash

/home/djnighs/.scripts/start_once_wrapper.sh alacritty -T alacritty -e tmux
      '';
    };
    "/home/djnighs/.scripts/start_nnn.sh" = {
      executable = true;
      text = ''
#!/usr/bin/env bash

/home/djnighs/.scripts/start_once_wrapper.sh alacritty -T nnn -e nnn
      '';
    };
    "/home/djnighs/.scripts/start_vieb_default.sh" = {
      executable = true;
      text = ''
#!/usr/bin/env bash

/home/djnighs/.scripts/start_once_wrapper.sh vieb --force_low_power_gpu --ignore-gpu-blacklist --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,WebContentsForceDark,VaapiVideoDecoder --ozone-platform=wayland
      '';
    };
    "/home/djnighs/.scripts/start_vieb_youtube.sh" = {
      executable = true;
      text = ''
        #TODO
      '';
    };
    "/home/djnighs/.scripts/start_firefox.sh" = {
      executable = true;
      text = ''
#!/usr/bin/env bash

MOZ_ENABLE_WAYLAND=1
/home/djnighs/.scripts/start_once_wrapper.sh firefox
      '';
    };
  };
}
