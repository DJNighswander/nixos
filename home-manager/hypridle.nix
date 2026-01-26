{config, ...}: {
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "playerctl --all-players pause && pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      
      listener = [	# monitor backlight (avoid 0 on OLED)
        #{
        #  timeout = 480;	# 8 minutes
        #  on-timeout = "brightnessctl -s set 10";
        #  on-resume = "brightnessctl -r";
        #}{
        #  timeout = 480; 	# 8 minutes
        #  on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
        #  on-resume = "brightnessctl -rd rgb:kbd_backlight";
        #}
        {
          timeout = 600;
          on-timout = "loginctl lock-session";
        }{
          timeout = 660;	# 11 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
        }
        #{
        #  timeout = 1800;	# 30 minutes
	      #}
      ];
    };
  };
}

