{ config, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
    };
  };

  environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";
  environment.systemPackages = with pkgs; [
    libvirt
    virt-viewer
    qemu_kvm
  ];

}
