{ config, pkgs, ... }:
{ 
  users.users.alexy = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      brave
    ];
  };
}
