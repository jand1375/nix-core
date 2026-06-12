{ config, pkgs, ... }:
{
  services.flatpak.enable = true;
  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }
  ];
  services.flatpak.packages = [
    "com.spotify.Client"
  ];
  # DELETES ANY IMPERATIVE FLATPAKS ON REBUILD
  services.flatpak.uninstallUnmanaged = true;
}
