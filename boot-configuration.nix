{ config, pkgs, ... }:

{
  boot.initrdkernelModules = [ "tpm" "tpm_tis" "tpm_crb" ];
  boot.initrd.luks.device."swap".device = "/dev/disk/by-label/LUKSSWAP"
}
