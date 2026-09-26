{ config, pkgs, inputs, ... }:

let
  mod = "Mod1";
  sup = "Mod4";
in
{
  imports = [ ../zen-common.nix ];

  home.username = "dock";
  home.homeDirectory = "/home/dock";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    CUPS_SERVER = "localhost:631";
  };

  home.packages = with pkgs; [
    btop
    google-cloud-sdk
    codex
    honeyfetch
    antigravity-ide
    firebase-tools
    python3
    ngrok
    jdk21_headless
    ripgrep
    yazi
    fzf
    smartmontools
    cups
    hplip
    system-config-printer
    gsmartcontrol
    xclip
    dunst
    dex
    xss-lock
    i3lock
    flameshot
    alacritty
    dmenu
    i3status
    i3blocks
    xdotool
    setxkbmap
    gcc
    gnumake
    go
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    clang-tools
    tree-sitter
    typescript-language-server
    gopls
    jdt-language-server
    freeglut
    libGL
    libGLU
    vscode
    zathura
    libreoffice
    vlc
    qbittorrent
    gh
    git
    kdePackages.dolphin
    pulseaudio
    pavucontrol
    mcpelauncher-ui-qt
    mcpelauncher-client
    polkit_gnome
    nodejs_26
    jq
    yq-go
    alloy6
    opencode
    cue
    typescript-language-server
    vscode-langservers-extracted
    rust-analyzer
    texlab
    nixd
    nixfmt-rfc-style
  ];

  xdg.portal.config.common.default = "*";

  home.file.".config/i3/toggle-layout.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env zsh
      set -e
      LAYOUT_A="br"
      LAYOUT_B="us"
      get_next_layout() {
        local current="$1"
        case "$current" in
          "$LAYOUT_A") echo "$LAYOUT_B" ;;
          "$LAYOUT_B") echo "$LAYOUT_A" ;;
          *) echo "$LAYOUT_B" ;;
        esac
      }
      if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
        current_layout=$(setxkbmap -query | awk '/layout:/ {print $2}' | cut -d',' -f1)
        next_layout=$(get_next_layout "$current_layout")
        setxkbmap "$next_layout"
      else
        current_layout=$(localectl status 2>/dev/null | awk -F': ' '/VC Keymap/ {print $2}')
        case "$current_layout" in
          br-abnt2|br-abnt|br) current_layout="br" ;;
          us) current_layout="us" ;;
          *) current_layout="unknown" ;;
        esac
        next_layout=$(get_next_layout "$current_layout")
        if [[ "$next_layout" == "br" ]]; then
          sudo loadkeys br-abnt2
        else
          sudo loadkeys us
        fi
      fi
    '';
  };

  # O restante do arquivo permanece igual ao arquivo enviado.
  # Toggle de suspensão: altere somente esta linha.
  home.file.".config/i3/toggle-sleep-inhibit.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      state_file="$HOME/.cache/sleep-inhibit-state"
      mkdir -p "$(dirname "$state_file")"

      if [[ -f "$state_file" ]]; then
        systemd-inhibit --user --list >/dev/null 2>&1 || true
        rm -f "$state_file"
        echo "Suspensão permitida"
        exit 0
      fi

      systemd-inhibit --user --what=sleep --why="Sleep disabled by user toggle" --mode=block sleep infinity &
      echo $! > "$state_file"
      echo "Suspensão bloqueada"
    '';
  };

  xsession.windowManager.i3.config.keybindings = {
    "${mod}+Shift+s" = "exec --no-startup-id ~/.config/i3/toggle-sleep-inhibit.sh";
  };

  programs.home-manager.enable = true;
}