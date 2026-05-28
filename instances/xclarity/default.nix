{ config, pkgs, ... }:
{
  virtualisation.libvirt.enable = true;
  virtualisation.libvirt.connections."qemu:///system" = {
    domains = [
      {
        definition = pkgs.writeText "xclarity-admin.xml" ''
            <domain type ='kvm'>
                <name>xclarity-administrator</name>
                <memory unit='GiB'>6</memory>
                <uuid>f0540388-0f5e-4aba-bc6b-23e8e25816f2</uuid>
                <vcpu placement='static'>4</vcpu>
             <os>
                <type arch='x86_64' machine='q35'>hvm</type>
             </os>
             <devices>
                <disk type='file' device='disk'>
                   <driver name='qemu' type='qcow2'/>
                   <source file='/var/lib/libvirt/images/clarity.qcow2'/>
                   <target dev='vda' bus='virtio'/>
                </disk>
               <interface type='network'>
                   <source network='default'/>
                   <model type='virtio'/>
               </interface>
               <graphics type='spice' autoport='yes'/>
             </devices>
          </domain> '';
        active = false;
      }
    ];
  };
}
