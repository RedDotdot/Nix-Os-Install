{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "tpm" "tpm_tis" "tpm_crb" ];
  boot.initrd.clevis.devices = {
    "root" = {
      device = "/dev/disk/by-label/LUKSROOT";
      tpm2 = true;
    };
    "swap" = {
      device = "/dev/disk/by-label/LUKSSWAP";
      tpm2 = true;
    };
  };
}
