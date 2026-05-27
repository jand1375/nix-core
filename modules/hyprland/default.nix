{ pkgs, ... }:
{
  programs.hyprland.enable = true;
  systemd.user.services.waybar.serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
}
