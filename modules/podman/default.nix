{ pkgs, ... }: {
# ENABLE PODMAM
virtualisation.podman = {
         enable = true;
         defaultNetwork.settings.dns_enabled = true;
                      };

# INSTALL DISTROBOX
environment.systemPackages = [ pkgs.distrobox pkgs.crun ];
}
