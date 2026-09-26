{ config, lib, pkgs, ... }:

{
  # Opção para controlar suspensão/hibernação
  powermanagement = {
    disableSuspend = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When true, prevent the system from suspending/hibernating";
    };
  };

  # Toggle: mude para true para impedir suspensão, false para permitir
  powermanagement.disableSuspend = false;

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
  ];

  programs.home-manager.enable = true;
}