{ config, pkgs, ... }:
{
  services.flatpak.enable = true;
  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://flathub.org";
    }
    {
      name = "GeForceNOW";
      location = "https://nvidia.com";
    }
  ];
  services.flatpak.packages = [
    "flathub:com.spotify.Client"
    "GeForceNOW:com.nvidia.geforcenow"
  ];
  # DELETES ANY IMPERATIVE FLATPAKS ON REBUILD
  services.flatpak.uninstallUnmanaged = true;
}
