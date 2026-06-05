# GBOOK LAPTOP HOST

{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../common/common.nix
    ../../modules/hyprland
    #    ../../modules/xfce
    ../../modules/podman
    ../../services/qemu
    ../../instances/xclarity
    ../../modules/fish
  ];
  home-manager.users.nyx = {
    home.stateVersion = "26.05";
    imports = [
      ../../modules/hyprland/home.nix
      ../../modules/neovim/home.nix
      ../../modules/yazi/home.nix
      ../../modules/neomutt/home.nix
      ../../modules/kitty/home.nix
    ];
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    alsa-utils
    alsa-tools
    wireplumber
    rot8
    prismlauncher
    qutebrowser
    cage
    pulsemixer
    brave
    qmapshack
  ];

  # BOOT AND KERNEL
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "systemd.show_status=true"
  ];
  boot.blacklistedKernelModules = [ "ucsi_acpi" ];

  # HARDWARE
  hardware.xpadneo.enable = true;
  hardware.steam-hardware.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.sensor.iio.enable = true;
  services.thermald.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NETWORKING
  networking.hostName = "gbook";
  networking.networkmanager.enable = true;

  # SOUND
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.openssh.enable = true;
  system.stateVersion = "26.05";
}
