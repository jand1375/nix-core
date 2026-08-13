{ config, pkgs, ... }:
{
  imports = [
  ./hardware-configuration.nix
  ../../common/common.nix
  ];

boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
 
  
networking.hostName = "bitecool";
networking.networkmanager.enable = true;

services.openssh = {
    enable = true;
	settings.PermitRootLogin = "yes";
	hostKeys = [
	    { path = "/persist/etc/ssh/ssh_host_ed25519_key"; type = "ed25519" }
		{ path = "/persist/etc/ssh/ssh_host_rsa_key"; type = "rsa"; }
	];
  };

   nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.root = {
    initialPassword = "nixos";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4LGh5VDbdRJZPDjhdUAMtFOuM5QCcpo/hJ9l9HbxYQ"
    ];
  };
  system.stateVersion = "26.05";
  
  
}