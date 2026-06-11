{ config, pkgs, ... }:
{
  services.flatpak.enable = true;
  systemd.services.flatpaks = {
    description = "Flatpak Repository";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutStartSec = "5min";
    };

    path = [
      pkgs.flatpak
      pkgs.gnugrep
    ];
    script = ''
                  flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      flatpak remote-add --system --if-not-exists GeForceNOW https://international.download.nvidia.com/GFNLinux/flatpak/geforcenow.flatpakrepo
               FLATHUB_APPS=(
                        "com.tradingview.tradingview"
                        "com.spotify.Client"
                            )
               for app in "''${FLATHUB_APPS[@]}"; do
                 if ! flatpak list --system --app | grep -q "$app"; then
                   flatpak install --system -y flathub "$app"
                   fi
                done
                 if ! flatpak list --system --app | grep -q "com.nvidia.geforcenow"; then
                   flatpak install --system -y GeForceNOW com.nvidia.geforcenow
                   fi
    '';
  };
}
