{ ... }: {
  home.file = {
    ".config/waybar/config.jsonc".text = ''
      {
        "layer": "bottom",
        "spacing": 0,
        "height": 0,

        "margin-top": 0,
        "margin-right": 0,
        "margin-bottom": 0,
        "margin-left": 0,

        "modules-left": [
	  "custom/toggle_keyboard",
          "hyprland/workspaces"
        ],

        "modules-center": [
          "clock"
        ],

        "modules-right": [
          "tray",
          "cpu_text",
          "cpu",
          "memory",
          "battery",
          "network",
          "pulseaudio",
        ],

        "hyprland/workspaces": {
          "disable-scroll": true,
          "all-outputs": true,
          "tooltip": false
        },

        "tray": {
          "spacing": 10,
          "tooltip": false
        },

        "clock": {
          "format": "{:%I:%M %p - %a, %d %b %Y}",
          "tooltip": false
        },

        "cpu": {
          "format": "cpu {usage}%",
          "interval": 2,

          "states": {
              "critical": 90
          }
        },

        "memory": {
          "format": "mem {percentage}%",
          "interval": 2,

          "states": {
              "critical": 80
          }
        },

        "battery": {
          "format": "bat {capacity}%",
          "interval": 5,
          "states": {
              "warning": 20,
              "critical": 10
          },
          "tooltip": false
        },

        "network": {
          "format-wifi" : "wifi {bandwidthDownBits}",
          "format-ethernet": "enth {bandwidthDownBits}",
          "format-disconnected" : "no network",
          "interval": 5,
          "tooltip": false
        },

        "pulseaudio": {
          "scroll-step": 5,
          "max-volume": 150,
          "format": "vol {volume}%",
          "format-bluetooth": "vol {volume}%",
          "nospacing": 1,
          "on-click": "pavucontrol",
          "tooltip": false
        },

	"custom/toggle_keyboard": {
	  "format": " ",
	  "exec": "/home/djnighs/.scripts/toggle_onscreen_keyboard.sh",
	  "on-click": "/home/djnighs/.scripts/toggle_onscreen_keyboard.sh click",
	  "interval": 1
	  /*"return-type": "json"*/
	}
      }
    '';

    ".config/waybar/style.css".text = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-weight: 500;
        font-size: 20px;
        padding: 0;
      }
      
      window#waybar {
        background: #1d2021;
        border: 0px solid #3c3836;
      }
      
      tooltip {
        background-color: #1d2021;
        border: 0px solid #7c6f64;
      }
      
      #clock,
      #tray,
      #cpu,
      #memory,
      #battery,
      #network,
      #pulseaudio {
        /*margin: 6px 6px 6px 0px;*/
        padding: 2px 8px;
      }
      
      #workspaces {
        background-color: #303536;
        /*margin: 6px 0px 6px 6px;*/
        border: 0px solid #434a4c;
      }
      
      #workspaces button {
        all: initial;
        min-width: 0;
        box-shadow: inset 0 -3px transparent;
        padding: 2px 4px;
        color: #c7ab7a;
      }
      
      #workspaces button.focused {
        color: #ddc7a1;
      }
      
      #workspaces button.urgent {
        background-color: #e78a4e;
      }
      
      #clock {
        background-color: #303536;
        border: 0px solid #434a4c;
        color: #d4be98;
      }
      
      #tray {
        background-color: #d4be98;
        border: 0px solid #c7ab7a;
      }
      
      #battery {
        background-color: #a9b665;
        border: 0px solid #c7ab7a;
        color: #6c782e;
      }
      
      #cpu,
      #memory,
      #network,
      #pulseaudio {
        background-color: #ddc7a1;
        border: 0px solid #c7ab7a;
        color: #1d2021;
      }
      
      #cpu.critical,
      #memory.critical {
        background-color: #ddc7a1;
        border: 0px solid #c7ab7a;
        color: #c14a4a;
      }
      
      #battery.warning,
      #battery.critical,
      #battery.urgent {
        background-color: #ddc7a1;
        border: 0px solid #c7ab7a;
        color: #c14a4a;
      }
    '';
  };
}
