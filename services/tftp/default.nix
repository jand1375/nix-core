{ config, pkgs, ... }:
{
  services.atftpd = {
         enable = true;
		 path = "/var/lib/tftboot";
 # Extra Arguments
  extraArgs = [ "--verbose=5" ];
  };
# Ensure the TFTP root directory exists permissions
  systemd.tmpfiles.rules = [ "d /var/lib/tftboot 0755 tftp tftp - -" ];
  
}