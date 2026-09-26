{ config, lib, pkgs, ... }:

{
  # ==========================================================================
  # POWER MANAGEMENT TOGGLE
  # ==========================================================================
  # disableSuspend = true  → impede suspensão/hibernação
  # disableSuspend = false → permite suspensão/hibernação
  # ==========================================================================
  powermanagement = {
    disableSuspend = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When true, prevent the system from suspending/hibernating";
    };
  };

  # Mude este valor para true/false conforme necessário
  powermanagement.disableSuspend = false;

  # ==========================================================================
  # SUA CONFIGURAÇÃO EXISTENTE DO HOME.NIX
  # ==========================================================================
  # (Cole aqui o conteúdo original do seu home.nix)
  # ==========================================================================

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
  ];

  programs.home-manager.enable = true;
}