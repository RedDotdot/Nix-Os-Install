{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "tpm" "tpm_tis" "tpm_crb" ];
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-label/LUKSSWAP";
  boot.initrd.systemd.extraBin = {
    clevis = "${pkgs.clevis}/bin/clevis";
  };
  boot.initrd.preLVMCommands = ''
    echo "Attempting to auto-unlock root via clevis"
    ${pkgs.clevis}/bin/clevis luks unlock -d /dev/disk/by-label/LUKSROOT -n root || echo "Clevis unlock failed"
    echo "Attempting to auto-unlock swap via clevis"
    ${pkgs.clevis}/bin/clevis luks unlock -d /dev/disk/by-label/LUKSSWAP -n swap || echo "Clevis unlock failed"
  '';
}
