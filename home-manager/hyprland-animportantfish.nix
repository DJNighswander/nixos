{ pkgs, lib, ... }: let
  activeBorder = "0xfe801900";
  inactiveBorder = "0x28282800";

  startupScript =
    pkgs.writeShellScriptBin "hyprland-init"
    ''
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.clipman}/bin/clipman &
      systemctl --user start xdg-desktop-portal-hyprland
      ${pkgs.rclone}/bin/rclone mount gdrive: /home/djnighs/documents/gdrive/
      #${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &

      ${pkgs.caffeine-ng}/bin/caffeine start &
    '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      exec = systemctl --user start hyprland-session.target
      exec-once = ${startupScript}/bin/hyprland-init

      $mod = SUPER;

      $terminal = /home/djnighs/.scripts/start_alacritty.sh
      $fileManager = /home/djnighs/.scripts/start_nnn.sh 
      $webBrowser = /home/djnighs/.scripts/start_firefox.sh 
      $hyprlock = ${pkgs.hyprlock}/bin/hyprlock
      $menu = ${pkgs.wofi}/bin/wofi --show drun

      env = XCURSOR_SIZE,16
      env = HYPRCURSOR_SIZE,16

      monitor = eDP-1 , 1920x1080@60 , auto-right, 1
      monitor = HDMI-A-1 , 2560x1440@60 , auto-left, 1

      workspace = 1, monitor:HDMI-A-1,eDP-1
      workspace = 2, monitor:HDMI-A-1,eDP-1
      workspace = 3, monitor:eDP-1
      workspace = 4, monitor:HDMI-A-1,eDP-1
      workspace = 5, monitor:HDMI-A-1,eDP-1
      workspace = 6, monitor:eDP-1
      workspace = 7, monitor:HDMI-A-1,eDP-1
      workspace = 8, monitor:HDMI-A-1,eDP-1
      workspace = 9, monitor:eDP-1
      workspace = 10, monitor:eDP-1

      general {
        gaps_in=0
	gaps_out=0
	border_size=2
	col.active_border=${activeBorder}
	col.inactive_border=${inactiveBorder}
	layout = dwindle
      }
      decoration {
        rounding = 0
        active_opacity = 1.0
        inactive_opacity = 0.50
        shadow {
          enabled = false
          range = 4
          render_power = 3
          color = rgba(1a1a1aee)
        }
        blur {
          enabled = true
          size = 3
          passes = 1
          vibrancy = 0.1696
        }
      }
      misc {
        disable_hyprland_logo=true
	disable_splash_rendering=true
      }
      animations {
        enabled = yes, please :)
        bezier = easeOutQuint,0.23,1,0.32,1
        bezier = easeInOutCubic,0.65,0.05,0.36,1
        bezier = linear,0,0,1,1
        bezier = almostLinear,0.5,0.5,0.75,1.0
        bezier = quick,0.15,0,0.1,1

        animation = global, 1, 10, default
        animation = border, 1, 5.39, easeOutQuint
        animation = windows, 1, 4.79, easeOutQuint
        animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
        animation = windowsOut, 1, 1.49, linear, popin 87%
        animation = fadeIn, 1, 1.73, almostLinear
        animation = fadeOut, 1, 1.46, almostLinear
        animation = fade, 1, 3.03, quick
        animation = layers, 1, 3.81, easeOutQuint
        animation = layersIn, 1, 4, easeOutQuint, fade
        animation = layersOut, 1, 1.5, linear, fade
        animation = fadeLayersIn, 1, 1.79, almostLinear
        animation = fadeLayersOut, 1, 1.39, almostLinear
        animation = workspaces, 1, 1.94, almostLinear, fade
        animation = workspacesIn, 1, 1.21, almostLinear, fade
        animation = workspacesOut, 1, 1.94, almostLinear, fade
      }
      dwindle {
        pseudotile = true
        preserve_split = true
	force_split=2
      }
      master {
        new_status = master
      }
      input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =
      
        follow_mouse = 1
      
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      
        touchpad {
            natural_scroll = true
        }


      }
      
      # https://wiki.hyprland.org/Configuring/Variables/#gestures
      #gestures {
      #  workspace_swipe = true
      #}
      
      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device {
        name = epic-mouse-v1
        sensitivity = -0.5
      }
      
      bind = $mod, 36, exec, $terminal # Return
      bind = $mod SHIFT, 36, exec, $webBrowser # Shift + Return
      bind = $mod, 24, killactive, # Q
      bind = $mod CONTROL SHIFT, 119, exit, # Control + Shift + Delete
      bind = $mod, 41, exec, $fileManager # F
      bind = $mod, 55, togglefloating, # V
      bind = $mod, 40, exec, $menu # D
      bind = $mod SHIFT, 46, exec, $hyprlock # Shift + L
      bind = $mod, 33, pseudo, # P
      bind = $mod, 44, togglesplit, # J
      
      bind = $mod, 46, movefocus, l # L
      bind = $mod, 43, movefocus, r # H
      bind = $mod, 45, movefocus, u # K
      bind = $mod, 44, movefocus, d # J
      
      bind = $mod, 113, movefocus, l # left arrow
      bind = $mod, 114, movefocus, r # right arrow
      bind = $mod, 111, movefocus, u # up arrow
      bind = $mod, 116, movefocus, d # down arrow
      
      bind = $mod, 10, workspace, 1 # 1
      bind = $mod, 11, workspace, 2 # 2
      bind = $mod, 12, workspace, 3 # 3
      bind = $mod, 13, workspace, 4 # 4
      bind = $mod, 14, workspace, 5 # 5
      bind = $mod, 15, workspace, 6 # 6
      bind = $mod, 16, workspace, 7 # 7
      bind = $mod, 17, workspace, 8 # 8
      bind = $mod, 18, workspace, 9 # 9
      bind = $mod, 19, workspace, 10 # 0 
      
      bind = $mod SHIFT, 10, movetoworkspace, 1 # Shift + 1
      bind = $mod SHIFT, 11, movetoworkspace, 2 # Shift + 2
      bind = $mod SHIFT, 12, movetoworkspace, 3 # Shift + 3
      bind = $mod SHIFT, 13, movetoworkspace, 4 # Shift + 4
      bind = $mod SHIFT, 14, movetoworkspace, 5 # Shift + 5
      bind = $mod SHIFT, 15, movetoworkspace, 6 # Shift + 6
      bind = $mod SHIFT, 16, movetoworkspace, 7 # Shift + 7
      bind = $mod SHIFT, 17, movetoworkspace, 8 # Shift + 8
      bind = $mod SHIFT, 18, movetoworkspace, 9 # Shift + 9
      bind = $mod SHIFT, 19, movetoworkspace, 10 # Shift + 0
      
      bind = $mod, 87, workspace, 1 # kp_1
      bind = $mod, 88, workspace, 2 # kp_2
      bind = $mod, 89, workspace, 3 # kp_3
      bind = $mod, 83, workspace, 4 # kp_4
      bind = $mod, 84, workspace, 5 # kp_5
      bind = $mod, 85, workspace, 6 # kp_6
      bind = $mod, 79, workspace, 7 # kp_7
      bind = $mod, 80, workspace, 8 # kp_8
      bind = $mod, 81, workspace, 9 # kp_9
      bind = $mod, 90, workspace, 10 # kp_0
      
      bind = $mod SHIFT, 87, movetoworkspace, 1 # Shift + kp_1
      bind = $mod SHIFT, 88, movetoworkspace, 2 # Shift + kp_2
      bind = $mod SHIFT, 89, movetoworkspace, 3 # Shift + kp_3
      bind = $mod SHIFT, 83, movetoworkspace, 4 # Shift + kp_4
      bind = $mod SHIFT, 84, movetoworkspace, 5 # Shift + kp_5
      bind = $mod SHIFT, 85, movetoworkspace, 6 # Shift + kp_6
      bind = $mod SHIFT, 79, movetoworkspace, 7 # Shift + kp_7
      bind = $mod SHIFT, 80, movetoworkspace, 8 # Shift + kp_8
      bind = $mod SHIFT, 81, movetoworkspace, 9 # Shift + kp_9
      bind = $mod SHIFT, 90, movetoworkspace, 10 # Shift + kp_0
      
      bind = $mod, 39, togglespecialworkspace, magic # S
      bind = $mod SHIFT, 39, movetoworkspace, special:magic # Shift + S
      
      bind = $mod, mouse_down, workspace, e+1
      bind = $mod, mouse_up, workspace, e-1
      
      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow
      
      bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
      bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-
      
      # Requires playerctl
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioPrev, exec, playerctl previous
      
      # Ignore maximize requests from apps. You'll probably like this.
      windowrulev2 = suppressevent maximize, class:.*
      
      # Fix some dragging issues with XWayland
      windowrulev2 = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0
    '';
  };  
}
