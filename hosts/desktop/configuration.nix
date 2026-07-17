{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../intel.nix
  ];

  networking.hostName = "desktop-nixos";
}
