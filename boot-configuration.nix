{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "tpm" "tpm_tis" "tpm_crb" ];
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-label/LUKSSWAP";
  boot.initrd.availablePackages = with pkgs; [
    clevis
    tpm2-tools
  ];
  boot.initrd.preLVMCommands = ''
    echo "Attempting to auto-unlock root via clevis"
    clevis luks unlock -d /dev/disk/by-label/LUKSROOT -n root || echo "Clevis unlock failed"
    echo "Attempting to auto-unlock swap via clevis"
    clevis luks unlock -d /dev/disk/by-label/LUKSSWAP -n swap || echo "Clevis unlock failed"
  '';
}
