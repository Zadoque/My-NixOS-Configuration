# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
 /* =============================================
     Configuração de GPU - Samsung NP700Z4A
     Desabilita Radeon, usa apenas Intel HD3000
     ============================================= 

  boot.blacklistedKernelModules = [ "radeon" ];

  boot.kernelParams = [
    "radeon.modeset=0"  # desabilita KMS da Radeon
    "i915.modeset=1"    # força Intel HD3000
  ];
  services.xserver.videoDrivers = [ "intel" ];
  */
  services.flatpak.enable = true;

  # Enable XDG Desktop Portals (Required for Flatpak sandboxing)
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # Recommended for GTK apps in i3

  # Enable Polkit (Required for authentication in GUI tools like Flatseal/GNOME Software)
  security.polkit.enable = true;
  services.desktopManager.gnome.enable = false;
  services.xserver = {
	enable = true;
	windowManager.i3 = {
		enable = true;
		extraPackages = with pkgs; [
			dmenu
			i3status
			i3lock
			i3blocks
		];
	};
  };
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dock = {
    isNormalUser = true;
    description = "zadoque";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
	neovim
	btop
	honeyfetch
	freeglut
	alacritty
	pulseaudio
	pavucontrol
	ripgrep
	yazi
	fzf
	qbittorrent
	gcc
	vscode
	flameshot
	git
	gh
	picom
	nitrogen
	go
	xclip
	rustc
  	cargo
  	rustfmt
  	clippy
  	rust-analyzer
	clang-tools
	nodePackages.typescript-language-server
	gopls
	jdt-language-server
	tree-sitter
	flatpak          # Command line tool (often pulled in by service, but good to be explicit)
  	gnome-software # GUI App Store (supports Flathub)
  	polkit_gnome     # Authentication agent for i3wm
	flatpak-builder
	flatpak-xdg-utils
	zathura
	libreoffice
	vlc
	gnumake
    	freeglut
    	libGL
	libGLU

    ];
  };

  users.users.natalia = {
    isNormalUser =  true;
    description = "Natalia";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    	vlc
    	brave
	chromium
    	libreoffice
	zathura
	kdePackages.okular
	flatpak          # Command line tool (often pulled in by service, but good to be explicit)
  	gnome-software # GUI App Store (supports Flathub)
  	polkit_gnome     # Authentication agent for i3wm
	flatpak-builder
	flatpak-xdg-utils
    ];
    password = "nat123";
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 6000 6001 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # Habilita o Zsh globalmente (obrigatório antes de tudo)
  programs.zsh = {
  	enable = true;
  	enableCompletion = true;       # Tab completion nativo
  	autosuggestions.enable = true; # Autosugestões do histórico
  	syntaxHighlighting.enable = true; # Syntax highlighting
  	ohMyZsh = {
    		enable = true;
    		theme = "robbyrussell";      # ou "agnoster", "af-magic", etc.
    		plugins = [ "git" "z" "sudo" ];
  	};
	 # Aqui vai o sourcing manual do plugin
   	interactiveShellInit = ''source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh'';
  };

# Define o Zsh como shell padrão do seu usuário
users.users.dock.shell = pkgs.zsh;

# IMPORTANTE: necessário para completions funcionarem corretamente
environment.pathsToLink = [ "/share/zsh" ];
  system.stateVersion = "25.11"; # Did you read the comment?

}
