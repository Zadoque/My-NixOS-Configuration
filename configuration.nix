{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ============================================
  # GPU — Samsung NP7004AZH
  # Desabilita Radeon (causa kernel panic),
  # usa apenas a GPU integrada Intel.
  # ============================================
  #boot.blacklistedKernelModules = [ "radeon" ];
  #boot.kernelParams = [
  # "radeon.modeset=0"
  # "i915.modeset=1"
  #];
  #services.xserver.videoDrivers = [ "intel" ];

  # ============================================
  # Boot
  # ============================================
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================
  # Rede
  # ============================================
  networking.hostName              = "nixos";
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
  # ============================================
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.displayManager.sddm.enable = true;

  # ============================================
  # Portais XDG
  # ============================================
  xdg.portal.enable      = true;
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
  # Zsh — obrigatório no sistema para shell de login
  # (configuração real fica no home.nix)
  # ============================================
  programs.zsh.enable      = true;
  environment.pathsToLink  = [ "/share/zsh" ];

  # ============================================
  # Usuários
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
    ];
  };

  # ============================================
  # Nix
  # ============================================
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    git
  ];

  system.stateVersion = "25.11";
}
