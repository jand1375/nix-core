{ config, pkgs, ... }:
{
  services.flatpak.enable = true;
  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }
    #    {
    #     name = "GeForceNOW";
    #    location = "https://international.download.nvidia.com/GNULinux/flatpak/geforcenow.flatpakrepo";
    #   }
  ];
  services.flatpak.packages = [
    "com.spotify.Client"
    #  "com.nvidia.geforcenow"
  ];
  # DELETES ANY IMPERATIVE FLATPAKS ON REBUILD
  services.flatpak.uninstallUnmanaged = true;
}
