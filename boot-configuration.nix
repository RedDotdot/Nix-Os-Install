{ config, pkgs, ... }:

{
  boot.initrdkernelModules = [ "tpm" "tpm_tis" "tpm_crb" ];
  boot.initrd.luks.device."swap".device = "/dev/disk/by-label/LUKSSWAP";
  boot.initrd.extraUtilsCommands = ''
    copy_bin_and_libs ${pkgs.clevis}/bin/clevis
    copy_bin_and_libs ${pkgs.clevis}/bin/clevis-luks-unlock
    copy_bin_and_libs ${pkgs.cryptsetup}/bin/cryptsetup
    copy_bin_and_libs ${pkgs.tpm2-tools}/bin/tpm2_unseal
  '';
  boot.initrd.preLVMCommands = ''
    echo "Attempting to auto-unlock root via clevis"
    clevis-luks-unlock -d /dev/disk/by-uuid/XYZ -n root || echo "Clevis unlock failed"
  '';
}
