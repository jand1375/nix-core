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
   boot.kernel.sysctl = { "net.ipv4.ip_forward" = 1; };
   networking.wireguard.interfaces."${config.services.cloudguard.interfaceName}" = {
                               ips = [ config.services.cloudguard.localIP ];
                        listenPort = config.services.cloudguard.privateKeyFile;
                    privateKeyFile = config.services.cloudguard.privateKeyFile;
                    postSetup = ''
           ${pkgs.iptables}/bin/iptables -A FORWARD -i ${config.service.cloudguard.interfaceName} -j ACCEPT
           ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE '';
                    postShutdown = ''
           ${pkgs.iptables}/bin/iptables -D FORWARD -i ${config.services.cloudguard.interfaceName} -j ACCEPT
           ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE '';
       peers = [
                 {
                    publicKey = config.services.cloudguard.opensensePublicKey;
                           allowedIPs = [
                           (builtins.head (lib.strings.splitString "/" config.services.cloudguard.localIP))
                             "10.10.10.2/32"
                             config.services.cloudguard.homeSubnet ];
                   }
                 ];
                                                                                  };
     };
}











   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
              			 
