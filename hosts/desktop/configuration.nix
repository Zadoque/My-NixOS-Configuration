{ config, lib, pkgs, ... }:

{
  # ==========================================================================
  # SUA CONFIGURAÇÃO EXISTENTE DO DESKTOP
  # ==========================================================================
  # (Cole aqui o conteúdo original do seu configuration.nix)
  # ==========================================================================

  imports = [
    ./hardware-configuration.nix
  ];

  # ==========================================================================
  # POWER MANAGEMENT TOGGLE - SYSTEMD TARGETS
  # ==========================================================================
  # Desabilita suspensão/hibernação apenas se powermanagement.disableSuspend = true
  # ==========================================================================
  systemd.targets = {
    sleep.wantedBy = lib.mkIf config.home-manager.users.zadoque.powermanagement.disableSuspend [ ];
    suspend.wantedBy = lib.mkIf config.home-manager.users.zadoque.powermanagement.disableSuspend [ ];
    hibernate.wantedBy = lib.mkIf config.home-manager.users.zadoque.powermanagement.disableSuspend [ ];
    hybrid-sleep.wantedBy = lib.mkIf config.home-manager.users.zadoque.powermanagement.disableSuspend [ ];
  };

  # Restante da configuração do desktop...
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  system.stateVersion = "24.05";
}