# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ============================================
  # Boot
  # ============================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================
  # Rede
  # ============================================
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 6000 6001 ];

  # ============================================
  # Locale e Teclado
  # ============================================
  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "pt_BR.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT    = "pt_BR.UTF-8";
    LC_MONETARY       = "pt_BR.UTF-8";
    LC_NAME           = "pt_BR.UTF-8";
    LC_NUMERIC        = "pt_BR.UTF-8";
    LC_PAPER          = "pt_BR.UTF-8";
    LC_TELEPHONE      = "pt_BR.UTF-8";
    LC_TIME           = "pt_BR.UTF-8";
  };

  services.xserver.xkb = {
    layout  = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";

  # ============================================
  # Servidor Gráfico + i3
  # (home-manager gerencia a config do i3;
  #  aqui só habilitamos o servidor e o WM)
  # ============================================
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;

  # Display manager
  services.displayManager.sddm.enable = true;

  # ============================================
  # Flatpak + Portais XDG
  # ============================================
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # ============================================
  # Segurança
  # ============================================
  security.polkit.enable = true;

  # ============================================
  # SSH
  # ============================================
  services.openssh.enable = true;

  # ============================================
  # Zsh — precisa estar habilitado no sistema
  # para funcionar como shell de login.
  # Toda a configuração real fica no home.nix.
  # ============================================
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  # ============================================
  # Usuários
  # (pacotes do usuário "dock" vivem no home.nix)
  # ============================================
  users.users.dock = {
    isNormalUser = true;
    description  = "zadoque";
    shell        = pkgs.zsh;
    extraGroups  = [ "networkmanager" "wheel" ];
  };

  users.users.natalia = {
    isNormalUser = true;
    description  = "Natalia";
    shell        = pkgs.bash;
    extraGroups  = [ "networkmanager" "wheel" ];
    password     = "nat123";
    packages = with pkgs; [
      vlc
      brave
      chromium
      libreoffice
      zathura
      kdePackages.okular
      flatpak
      gnome-software
      polkit_gnome
      flatpak-builder
      flatpak-xdg-utils
    ];
  };

  # ============================================
  # Nix
  # ============================================
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    # ferramentas mínimas de sistema
    git
  ];

  system.stateVersion = "25.11";
}
