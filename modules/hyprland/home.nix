{ config, pkgs, ... }:
{
   home.packages = with pkgs; [ rofi ];
   programs.waybar.enable = true;

   xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
   xdg.configFile."waybar/config".source = ./waybar-config.json;
   xdg.configFile."waybar/style.css".source = ./waybar-style.css;

 }
