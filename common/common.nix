# This is a common configuration file for all hosts

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Basic System Settings
  system.nixos.distroName = "NixOS";
  system.nixos.label = "Nix-Core";
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Global Packages (Every host gets these)
  environment.systemPackages = with pkgs; [
    git
    gh
    fastfetch
    glances
    curl
    tmux
    rsync
    cpio
    htop
    util-linux
    nmap
    ticker
    openssl
    glab
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # User Account Configuration
  users.users.nyx = {
    isNormalUser = true;
    description = "nyx";
    extraGroups = [
      "networkmanager"
      "wheel"
      "users"
      "input"
      "video"
      "libvirtd"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4LGh5VDbdRJZPDjhdUAMtFOuM5QCcpo/hJ9l9HbxYQ"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/hlQl0smIa28Y3kCoRl6OGZFb2PRhDGlZRC50pIGt/"
    ];

    initialPassword = "nixos";
  };
  # Global Home Manager Settings
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
  };
  # Experimental features for Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
