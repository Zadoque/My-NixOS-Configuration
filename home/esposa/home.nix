{ config, pkgs, inputs, ... }:
{
  imports = [ ../zen-common.nix ];

  home.username = "natalia";
  home.homeDirectory = "/home/natalia";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    vlc
    libreoffice
    zathura
    kdePackages.okular
    kdePackages.dolphin
  ];

  programs.home-manager.enable = true;
}
