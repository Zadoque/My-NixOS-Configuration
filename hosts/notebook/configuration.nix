{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../intel.nix
  ];

  boot.blacklistedKernelModules = [ "radeon" ];
  boot.kernelParams = [ "radeon.modeset=0" ];

  networking.hostName = "notebook-nixos";
}
