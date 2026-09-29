{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../common/common.nix
    ../../services/prometheus
    #    ../../services/tftp
  ];

  home-manager.users.nyx = {
    home.stateVersion = "26.05";
    imports = [
      ../../modules/neovim/home.nix
      ../../modules/bash/home.nix
    ];
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  users.users.root = {
    initialPassword = "nixos";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4LGh5VDbdRJZPDjhdUAMtFOuM5QCcpo/hJ9l9HbxYQ"
    ];
  };

  users.mutableUsers = true;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
    settings.PasswordAuthentication = true;
  };

  networking.hosts = {
    "10.0.0.10" = [ "controller" ];
    "10.0.0.11" = [ "compute1" ];
    "10.0.0.12" = [ "compute2" ];
  };

  networking.hostName = "sophos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  networking.nftables.enable = true;
  networking.useDHCP = false;
  # DNS
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  # Default route to ISR4331
  networking.defaultGateway = "10.99.0.254";
  # Enable IPV4 Routing
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # Managemnt for Arista7010T
  networking.interfaces.enp7s0.ipv4.addresses = [
    {
      address = "192.168.10.3";
      prefixLength = 24;
    }
  ];

  # Transit Network to Cisco vlan90
  networking.interfaces.enp5s0.ipv4.addresses = [
    {
      address = "10.90.0.2";
      prefixLength = 24;
    }
  ];
  # Outside Network to Cisco ISR4331
  networking.interfaces.enp6s0.ipv4.addresses = [
    {
      address = "10.99.0.2";
      prefixLength = 24;
    }
  ];
  # Openstack Control/API monitoring Arista 7010T VLAN 80
  networking.interfaces.enp3s0f1.ipv4.addresses = [
    {
      address = "10.0.0.13";
      prefixLength = 24;
    }
  ];

  networking.nftables.ruleset = ''
         table inet filter {
           chain input {
              type filter hook input priority 0;
              policy drop;
              iifname "lo" accept
              ct state established,related accept
      # Allow ping
                  ip protocol icmp accept
     
    # Allow TCP SERRVICES FROM INTERNAL VLANS
                ip saddr { 10.10.0.0/24, 10.20.0.0/24, 10.30.0.0/24, 10.40.0.0/24,
                           10.50.0.0/24, 10.60.0.0/24 }
                tcp dport { 22, 3000, 8000, 9090, 9443 } accept
                        
    # ALLOW TFTP (UDP 69) FROM INTERNAL VLANS
                ip saddr { 10.10.0.0/24, 10.20.0.0/24, 10.30.0.0/24, 10.40.0.0/24,
                           10.50.0.0/24, 10.60.0.0/24 } 
                  udp dport 69 accept 
               }

              chain forward {
              type filter hook forward priority 0;
              policy drop;
              ct state established,related accept
      # Allow internal vlans toward ISR
              iifname "enp5s0" oifname "enp6s0" ip saddr { 10.10.0.0/24, 10.20.0.0/24,
                                  10.30.0.0/24, 10.40.0.0/24, 10.50.0.0/24, 10.60.0.0/24, } accept
                         }
         chain output {
               type filter hook output priority 0;
               policy accept;
                      }
                        }
  '';
  # Static Routes
  networking.interfaces.enp5s0.ipv4.routes = [
    {
      address = "10.10.0.0";
      prefixLength = 24;
      via = "10.90.0.1";
    }
    {
      address = "10.20.0.0";
      prefixLength = 24;
      via = "10.90.0.1";
    }
    {
      address = "10.30.0.0";
      prefixLength = 24;
      via = "10.90.0.1";
    }
    {
      address = "10.40.0.0";
      prefixLength = 24;
      via = "10.90.0.1";
    }
    {
      address = "10.50.0.0";
      prefixLength = 24;
      via = "10.90.0.1";
    }
    {
      address = "10.60.0.0";
      prefixLength = 24;
      via = "10.90.0.1";
    }
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "26.05";

}
