{ config, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 6000 6001 ];

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "pt_BR.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";

  services.xserver.windowManager.i3.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  security.polkit.enable = true;
  services.openssh.enable = true;

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  users.users.dock = {
    isNormalUser = true;
    description = "zadoque";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  users.users.natalia = {
    isNormalUser = true;
    description = "Natalia";
    shell = pkgs.bash;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      vlc
      brave
      chromium
      libreoffice
      zathura
      kdePackages.okular
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    git
    libva-utils
    pciutils
    libxcb-cursor
  ];

  system.stateVersion = "26.05";
}
