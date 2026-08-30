{ pkgs, ... }:
{
   disko.devices = {
                nodev."/" = {
				    fsType = "tmpfs";
			  mountOptions = [ "size=4G" "mode=755" ];
			                };
				 disk.main = {
			        device = "/dev/CHANGE_THIS";
			        type = "disk";
			                content = {
			                            type = "gpt";
	                                    partitions = {
														ESP = {
														        size = "512M";
																type = "EF00";
						content = {
						         type = "filesystem";
								 format = "vfat";
								 mountpoint = "/boot";
								 mountOptions = [ "umask=0077" ];
								 };
														};
						nix = {
						    size = "50G";
							content = {
							     type = "filesystem";
								 format = "xfx";
								 mountpoint = "/nix";
								       };
								};
						persist = {
						       size = "100%";
							   content = {
							       type = "xfs";
								   mountpoint = "/persist";
								   };
								 };
							   };
							 };
						   };
						 };
														
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
fileSystems."/".neededForBoot = true;

services.openssh = {
     enable = true;
	 settings.PerminRootLogin = "yes";
	  };
	  
users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4LGh5VDbdRJZPDjhdUAMtFOuM5QCcpo/hJ9l9HbxYQ" ];

system.stateVersion = "26.05";
}












