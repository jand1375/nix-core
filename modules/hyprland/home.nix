{ config, pkgs, ... }:
{
  # HYPRLAND CONFIG
  
wayland.windowManager.hyprland = {
  enable = true;
  systemd.enable = true;
  xwayland.enable = true;
  configType = "lua";

  settings = {
    monitor = [
      {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = 1;
      }
    ];

    exec_once = [ "rot8" ];

    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;

      col = {
        active_border = {
          colors = [
            "rgba(33cceeee)"
            "rgba(00ff99ee)"
          ];
          angle = 45;
        };
        inactive_border = "rgba(595959aa)";
      };

      layout = "dwindle";
      allow_tearing = false;
    };

    decoration = {
      rounding = 10;

      blur = {
        enabled = true;
        size = 8;
        passes = 3;
        new_optimizations = true;
        xray = false;
      };

      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "rgba(1a1a1aae)";
      };
    };

    animations = {
      enabled = true;
    };

    curve = {
      myBezier = {
        type = "bezier";
        points = [
          [ 0.05 0.9 ]
          [ 0.1 1.05 ]
        ];
      };
    };

    animation = [
      {
        leaf = "windows";
        enabled = true;
        speed = 5;
        bezier = "myBezier";
      }
      {
        leaf = "windowsOut";
        enabled = true;
        speed = 5;
        bezier = "default";
        style = "popin 80%";
      }
      {
        leaf = "border";
        enabled = true;
        speed = 10;
        bezier = "default";
      }
      {
        leaf = "borderangle";
        enabled = true;
        speed = 8;
        bezier = "default";
      }
      {
        leaf = "fade";
        enabled = true;
        speed = 5;
        bezier = "default";
      }
      {
        leaf = "workspaces";
        enabled = true;
        speed = 5;
        bezier = "default";
        style = "slide";
      }
    ];

    bind = [
      {
        key = "SUPER + RETURN";
        dispatcher = "exec";
        arg = "kitty";
      }
      {
        key = "SUPER + R";
        dispatcher = "exec";
        arg = "sh -c 'pkill rofi || rofi -show drun'";
      }
      {
        key = "SUPER + M";
        dispatcher = "exit";
      }

      {
        key = "SUPER + Q";
        dispatcher = "killactive";
      }
      {
        key = "SUPER + F";
        dispatcher = "fullscreen";
        arg = 0;
      }
      {
        key = "SUPER + P";
        dispatcher = "fullscreen";
        arg = 1;
      }
      {
        key = "SUPER + SPACE";
        dispatcher = "togglefloating";
      }

      {
        key = "SUPER + h";
        dispatcher = "movefocus";
        arg = "l";
      }
      {
        key = "SUPER + l";
        dispatcher = "movefocus";
        arg = "r";
      }
      {
        key = "SUPER + k";
        dispatcher = "movefocus";
        arg = "u";
      }
      {
        key = "SUPER + j";
        dispatcher = "movefocus";
        arg = "d";
      }

      {
        key = "SUPER + 1";
        dispatcher = "workspace";
        arg = 1;
      }
      {
        key = "SUPER + 2";
        dispatcher = "workspace";
        arg = 2;
      }
      {
        key = "SUPER + 3";
        dispatcher = "workspace";
        arg = 3;
      }
      {
        key = "SUPER + 4";
        dispatcher = "workspace";
        arg = 4;
      }
      {
        key = "SUPER + 5";
        dispatcher = "workspace";
        arg = 5;
      }
      {
        key = "SUPER + 6";
        dispatcher = "workspace";
        arg = 6;
      }
      {
        key = "SUPER + 7";
        dispatcher = "workspace";
        arg = 7;
      }
      {
        key = "SUPER + 8";
        dispatcher = "workspace";
        arg = 8;
      }

      {
        key = "SUPER + SHIFT + 1";
        dispatcher = "movetoworkspace";
        arg = 1;
      }
      {
        key = "SUPER + SHIFT + 2";
        dispatcher = "movetoworkspace";
        arg = 2;
      }
      {
        key = "SUPER + SHIFT + 3";
        dispatcher = "movetoworkspace";
        arg = 3;
      }
      {
        key = "SUPER + SHIFT + 4";
        dispatcher = "movetoworkspace";
        arg = 4;
      }
      {
        key = "SUPER + SHIFT + 5";
        dispatcher = "movetoworkspace";
        arg = 5;
      }
      {
        key = "SUPER + SHIFT + 6";
        dispatcher = "movetoworkspace";
        arg = 6;
      }
      {
        key = "SUPER + SHIFT + 7";
        dispatcher = "movetoworkspace";
        arg = 7;
      }
      {
        key = "SUPER + SHIFT + 8";
        dispatcher = "movetoworkspace";
        arg = 8;
      }
    ];

    bindm = [
      {
        key = "SUPER + mouse:272";
        dispatcher = "movewindow";
      }
      {
        key = "SUPER + mouse:273";
        dispatcher = "resizewindow";
      }
    ];

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };
  };
};
		  
		  

  # ROFI CONFIGURATION BLOCK
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,run,window";
      sidebar-mode = true;
      show-icons = true;
      terminal = "kitty";
    };
  };

  # WAYBAR CONFIGURATION BLOCK
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "graphical-session.target" ];
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "cpu"
          "memory"
          "network"
          "pulseaudio"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          active-only = false;
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            default = (builtins.fromJSON "\"\\uf111\"");
          };
        };
        "clock" =
          let
            calendarIcon = builtins.fromJSON "\"\\uf073\"";
            timeIcon = builtins.fromJSON "\"\\udb84\\udcb2\"";
          in
          {
            timezone = "America/New_York";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format = "${calendarIcon} {:%a %b %d ${timeIcon} %I:%M %p}";
          };
        "cpu" = {
          interval = 10;
          format = (builtins.fromJSON "\"\\uf4bc\"") + " {usage}%";
          max-length = 10;
        };
        "memory" = {
          interval = 10;
          format = (builtins.fromJSON "\"\\ue266\"") + " {used:0.1f}G";
          max-length = 10;
        };
        "network" =
          let
            ethernetIcon = builtins.fromJSON "\"\\udb80\\udee0\"";
            disconnectedIcon = builtins.fromJSON "\"\\udb81\\uddba\"";
          in
          {
            format-wifi = (builtins.fromJSON "\"\\uf1eb\"") + " {essid}";
            format-ethernet = "${ethernetIcon} {ipaddr}/{cidr}";
            format-disconnected = "${disconnectedIcon} Disconnected";
            tooltip-format = "${ethernetIcon} {ifname} via {gwaddr}";
            "on-click" = "kitty --class floating_term -e nmtui";
          };
        "pulseaudio" =
          let
            mutedIcon = builtins.fromJSON "\"\\udb81\\udf5f\"";
            lowIcon = builtins.fromJSON "\"\\udb81\\uddf7\"";
            medIcon = builtins.fromJSON "\"\\udb81\\uddff\"";
            highIcon = builtins.fromJSON "\"\\udb81\\uddf5\"";
          in
          {
            format = "{icon} {volume}%";
            format-muted = "${mutedIcon} Muted";
            format-icons = {
              default = [
                lowIcon
                medIcon
                highIcon
              ];
            };
            "on-scroll-up" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
            "on-scroll-down" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
            "on-click" = "kitty --class floating_term -e pulsemixer";
          };
        "battery" =
          let
            dischargingIcon = builtins.fromJSON "\"\\udb80\\udf43\"";
            chargingIcon = builtins.fromJSON "\"\\udb80\\udf4a\"";
          in
          {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "${dischargingIcon} {capacity}%";
            format-charging = "${chargingIcon} {capacity}%";
            format-plugged = "${chargingIcon} {capacity}%";
            format-alt = "{time} {icon}";
          };
        "tray" = {
          icon-size = 16;
          spacing = 10;
        };
      };
    };

    # WAYBAR CSS STYLING BLOCK
    style = ''
      * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font", "FiraCode Nerd Font", sans-serif;
          font-size: 16px;
          min-height: 0;
        }
          window#waybar {
                  background-color: rgba(21, 22, 30, 0.85);
                  color: #c0caf5;
                  transition-property: background-color;
                  transition-duration: .5s;
                  border-radius: 12px;
                  border: 1.5px solid #ff003c;
                  box-shadow: 0 0 10px rgba(255, 0, 60, 0.5), inset 0 0 6px rgba(255, 0, 60, 0.3);
        }
          #battery {
               color: #a9b1d6;
        }
          #battery.warning {
               color: #ff9e64;
        }
          #battery.critical {
               color: #f7768e;
        }
          
          window#waybar.hidden {
                   opacity: 0.2;
        }
           #workspaces {
                    background-color: #1a1b26;
                    margin: 4px;
                    padding: 0 4px;
                    border-radius: 10px;
         }
            #workspaces button {
                     padding: 0 8px;
                     color: #a9b1d6;
                     background-color: transparent;
          }
             #workspaces button.active {
                      color: #ff003c;
                      font-weight: bold;
          }
            #workspaces button.urgent {
                      color: #f7768e;
          }
              #clock,
              #cpu,
              #memory,
              #network,
              #pulseaudio,
              #tray {
                       background-color: #1a1b26;
                       padding: 0 18px;
                       margin: 4px 3px;
                       border-radius: 8px;
                       border: 1px solid #ff003c;
                       box-shadow: 0 0 6px rgba(255, 0, 60, 0.4);
                     }
              #clock {
                       color: #7aa2f7;
                       font-weight: bold;
                     }
                #cpu { color: #b4f9a8; }
                #memory { color: #ff9e64; }
                #network { color: #7dcfff; }
                #pulseaudio { color: #bb9af7; }
                #tray { margin-right: 4px; }
    '';
  };
}
