{ config, pkgs, ... }:
{
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
            systemd.enable = true;
                    settings = {
                                  mainBar = {
                                          layer = "top";
                                          position = "top";
                                          height = 32;
                                          spacing = 4;
                                          margin-top = 6;
                                          margin-left = 10;
                                          margin-right = 10;
                                          modules-left = [ "hyprland/workspaces" "hyprland/submap" ];
                                          modules-center = [ "clock" ];
                                          modules-right = [ "cpu" "memory" "network" "pulseaudio" "battery" "tray" ];

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
                                                       "clock" = let
                                                            calendarIcon = builtins.fromJSON "\"\\uf073\"";
                                                            timeIcon =     builtins.fromJSON "\"\\udb84\\udcb2\"";
                                                                in {
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
                                                     "network" = let
                                                                ethernetIcon = builtins.fromJSON "\"\\udb80\\udee0\"";
                                                                disconnectedIcon = builtins.fromJSON "\"\\udb81\\uddba\"";
                                                                 in {
                                                                format-wifi = (builtins.fromJSON "\"\\uf1eb\"") + " {essid}";
                                                                format-ethernet = "${ethernetIcon} {ipaddr}/{cidr}";
                                                                format-disconnected = "${disconnectedIcon} Disconnected";
                                                                tooltip-format = "${ethernetIcon} {ifname} via {gwaddr}";
                                                                "on-click" = "kitty --class floating_term -e nmtui";
                                                                 };
                                                  "pulseaudio" = let
                                                                 mutedIcon = builtins.fromJSON "\"\\udb81\\udf5f\"";
                                                                   lowIcon = builtins.fromJSON "\"\\udb81\\uddf7\"";
                                                                   medIcon = builtins.fromJSON "\"\\udb81\\uddff\"";
                                                                  highIcon = builtins.fromJSON "\"\\udb81\\uddf5\"";
                                                                  in {
                                                                  format = "{icon} {volume}%";
                                                            format-muted = "${mutedIcon} Muted";
                                                                format-icons = {
                                                                      default = [ lowIcon medIcon highIcon ];
                                                                                };
                                                              "on-scroll-up" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
                                                            "on-scroll-down" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
                                                                  "on-click" = "kitty --class floating_term -e pulsemixer";
                                                                  };
                                                        "battery" = let
                                                                  dischargingIcon = builtins.fromJSON "\"\\udb80\\udf43\"";
                                                                     chargingIcon = builtins.fromJSON "\"\\udb80\\udf4a\"";
                                                                   in {
                                                                   states = { warning = 30; critical = 15; };
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
                background-color: rgba(21, 22, 30, 0.7);
                color: #c0caf5;
                transition-property: background-color;
                transition-duration: .5s;
                border-radius: 12px;
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
                    color: #7aa2f7;
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

    xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

}
