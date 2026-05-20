{ config, lib, pkgs, ... }:
 {
     services.cloudguard.enable = true;
	 options.services.cloudguard = with lib;
	        { enable = mkEnableOption "Custom WireGuard Relay Service";
			  interfaceName = mkOption 
			               { type = types.str;
						     default = "wg0"
						   };
			   localIP = mkOption
			               { type = types.str;
						     default = "10.10.10.1/24";
						   };
			   listenPort = mkOption
			               { type = types.port;
						     default = 51820;
						   };
			   privateKeyFile = mkOption
			               { type = types.path;
						     default = "/var/lib/wireguard/private.key";
						   };
		  opensensePublicKey = mkOption
		                   { type = types.str;
						     default = "PLACEHOLDER FOR KEY";
						   };
				  homeSubnet = mkOption
				           { type = types.str;
						     default = "192.168.1.0/24";
						   };
				};
				
config = lib.mkIF config.services.cloudguard.enable
{
   environment.systemPackages = [ pkgs.wireguard-tools];
   networking.frewall.allowedUDPPorts = [ config.services.cloudguard.listenPort ];
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
              			 