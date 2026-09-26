{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../intel.nix
  ];

  networking.hostName = "desktop-nixos";

  # Toggle disponível somente no perfil de Zadoque (login: dock) neste host.
  home-manager.users.dock.imports = [ ../../home/zadoque/sleep-toggle.nix ];
}
