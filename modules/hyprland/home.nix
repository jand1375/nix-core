{ config, pkgs, ... }:
{
   programs.rofi = {
           enable = true;
           package = pkgs.rofi;
           extraConfig = {
                           modi = "drun,run,window";
                           sidebar-mode = true;
                           show-icons = true;
                           terminal = "kitty";
                         };
                     };


   programs.waybar.enable = true;

   xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
   xdg.configFile."waybar/config".source = ./waybar-config.json;
   xdg.configFile."waybar/style.css".source = ./waybar-style.css;

 }
