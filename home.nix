{ config, pkgs, inputs, ... }:

{
  home.username      = "dock";
  home.homeDirectory = "/home/dock";
  home.stateVersion  = "25.11";

  # ============================================
  # Pacotes do usuário
  # ============================================
  home.packages = with pkgs; [
    # Terminal / CLI
    btop
    honeyfetch
    ripgrep
    yazi
    fzf
    xclip
    dunst
    dex
    xss-lock
    i3lock
    nitrogen
    flameshot
    alacritty
    dmenu
    i3status
    i3blocks
    xdotool
    setxkbmap

    # Browsers
    inputs.zen-browser.packages.${pkgs.system}.default

    # Desenvolvimento
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
    nodePackages.typescript-language-server
    gopls
    jdt-language-server

    # OpenGL / Graphics
    freeglut
    libGL
    libGLU

    # Produtividade
    vscode
    zathura
    libreoffice
    vlc
    qbittorrent
    gh

    # Áudio
    pulseaudio
    pavucontrol

    # Flatpak tooling
    flatpak
    gnome-software
    polkit_gnome
    flatpak-builder
    flatpak-xdg-utils
  ];

  # ============================================
  # Script toggle-layout.sh
  # ============================================
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
          *)           echo "$LAYOUT_B" ;;
        esac
      }

      if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
        if ! command -v setxkbmap >/dev/null 2>&1; then
          echo "Erro: setxkbmap não encontrado."
          exit 1
        fi
        current_layout=$(setxkbmap -query | awk '/layout:/ {print $2}' | cut -d',' -f1)
        next_layout=$(get_next_layout "$current_layout")
        echo "Layout atual (X/Wayland): ${current_layout:-desconhecido}"
        echo "Alternando para: $next_layout"
        setxkbmap "$next_layout"
        echo "Novo layout aplicado: $next_layout"
      else
        if ! command -v loadkeys >/dev/null 2>&1; then
          echo "Erro: loadkeys não encontrado."
          exit 1
        fi
        if ! command -v localectl >/dev/null 2>&1; then
          echo "Erro: localectl não encontrado."
          exit 1
        fi
        current_layout=$(localectl status 2>/dev/null | awk -F': ' '/VC Keymap/ {print $2}')
        case "$current_layout" in
          br-abnt2|br-abnt|br) current_layout="br" ;;
          us)                  current_layout="us" ;;
          *)                   current_layout="unknown" ;;
        esac
        next_layout=$(get_next_layout "$current_layout")
        echo "Layout atual (TTY): $current_layout"
        echo "Alternando para: $next_layout"
        if [[ "$next_layout" == "br" ]]; then
          sudo loadkeys br-abnt2
          echo "Novo layout aplicado: br-abnt2"
        else
          sudo loadkeys us
          echo "Novo layout aplicado: us"
        fi
      fi
    '';
  };

  # ============================================
  # i3 — Window Manager
  # ============================================
  xsession.windowManager.i3 = {
    enable  = true;
    package = pkgs.i3;

    config = {
      modifier = "Mod1";

      fonts = {
        names = [ "monospace" ];
        size  = 8.0;
      };

      defaultBorder = "none";

      gaps = {
        inner  = 3;
        outer  = 3;
        top    = 3;
        bottom = 3;
        smartGaps = true;
      };

      startup = [
        { command = "dex --autostart --environment i3";              notification = false; }
        { command = "picom -b";                                       notification = false; }
        { command = "nitrogen --restore";                             notification = false; }
        { command = "xss-lock --transfer-sleep-lock -- i3lock --nofork"; notification = false; }
        { command = "nm-applet";                                      notification = false; }
        { command = "dunst";                                          notification = false; }
      ];

      keybindings = let mod = "Mod1"; sup = "Mod4"; in {
        # Terminal e apps
        "${mod}+Return" = "exec --no-startup-id alacritty";
        "${mod}+z"      = "exec --no-startup-id app.zen_browser.zen";
        "${mod}+o"      = "exec --no-startup-id i3lock";
        "${mod}+r"      = "exec reboot";
        "${mod}+p"      = "exec poweroff";
        "${mod}+d"      = "exec --no-startup-id dmenu_run";
        "Print"         = "exec flameshot gui";

        # Toggle layout de teclado
        "${mod}+space" = "exec ~/.config/i3/toggle-layout.sh";

        # Volume (Super)
        "${sup}+8" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +1%";
        "${sup}+7" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -1%";
        "${sup}+6" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "${sup}+5" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        # Fechar janela
        "${mod}+Shift+q" = "kill";

        # Foco (hjkl + setas)
        "${mod}+h"     = "focus left";
        "${mod}+j"     = "focus up";
        "${mod}+k"     = "focus down";
        "${mod}+l"     = "focus right";
        "${mod}+Left"  = "focus left";
        "${mod}+Down"  = "focus down";
        "${mod}+Up"    = "focus up";
        "${mod}+Right" = "focus right";

        # Mover janela
        "${mod}+Shift+h"     = "move left";
        "${mod}+Shift+j"     = "move up";
        "${mod}+Shift+k"     = "move down";
        "${mod}+Shift+l"     = "move right";
        "${mod}+Shift+Left"  = "move left";
        "${mod}+Shift+Down"  = "move down";
        "${mod}+Shift+Up"    = "move up";
        "${mod}+Shift+Right" = "move right";

        # Split
        "${sup}+h" = "split h";
        "${sup}+v" = "split v";

        # Layout
        "${mod}+f"           = "fullscreen toggle";
        "${mod}+s"           = "layout stacking";
        "${mod}+w"           = "layout tabbed";
        "${mod}+e"           = "layout toggle split";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+m"           = "focus mode_toggle";
        "${mod}+a"           = "focus parent";

        # Workspaces — trocar
        "${mod}+1" = "workspace number 1";
        "${mod}+2" = "workspace number 2";
        "${mod}+3" = "workspace number 3";
        "${mod}+4" = "workspace number 4";
        "${mod}+5" = "workspace number 5";
        "${mod}+6" = "workspace number 6";
        "${mod}+7" = "workspace number 7";
        "${mod}+8" = "workspace number 8";
        "${mod}+9" = "workspace number 9";
        "${mod}+0" = "workspace number 10";

        # Workspaces — mover janela
        "${mod}+Shift+1" = "move container to workspace number 1";
        "${mod}+Shift+2" = "move container to workspace number 2";
        "${mod}+Shift+3" = "move container to workspace number 3";
        "${mod}+Shift+4" = "move container to workspace number 4";
        "${mod}+Shift+5" = "move container to workspace number 5";
        "${mod}+Shift+6" = "move container to workspace number 6";
        "${mod}+Shift+7" = "move container to workspace number 7";
        "${mod}+Shift+8" = "move container to workspace number 8";
        "${mod}+Shift+9" = "move container to workspace number 9";
        "${mod}+Shift+0" = "move container to workspace number 10";

        # i3 controle
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Sair do i3?' -B 'Sim' 'i3-msg exit'";

        # Modo resize
        "${mod}+t" = "mode resize";
      };

      modes = {
        resize = {
          h      = "resize shrink width 20 px or 20 ppt";
          j      = "resize grow height 20 px or 20 ppt";
          k      = "resize shrink height 20 px or 20 ppt";
          l      = "resize grow width 20 px or 20 ppt";
          Left   = "resize shrink width 20 px or 20 ppt";
          Down   = "resize grow height 20 px or 20 ppt";
          Up     = "resize shrink height 20 px or 20 ppt";
          Right  = "resize grow width 20 px or 20 ppt";
          Return  = "mode default";
          Escape  = "mode default";
          "${mod}+t" = "mode default";
        };
      };

      bars = [{
        statusCommand = "i3status";
      }];
    };
  };

  # ============================================
  # Picom — Compositor
  # ============================================
  services.picom = {
    enable  = true;
    backend = "glx";
    vSync   = true;

    shadow        = true;
    fading        = true;

    activeOpacity   = 0.95;
    inactiveOpacity = 0.90;

    opacityRules = [
      "90:class_g = 'Alacritty'"
      "90:class_g = 'XTerm'"
      "95:class_g = 'Thunar'"
    ];

    settings = {
      corner-radius     = 10;
      round-borders     = 1;
      frame-opacity     = 0.90;
      inactive-opacity-override = false;
    };
  };

  # ============================================
  # Zsh
  # ============================================
  programs.zsh = {
    enable = true;

    history = {
      size = 3000;
      save = 3000;
      path = "${config.home.homeDirectory}/.histfile";
    };

    initContent = ''
      # Completion styles (compinstall)
      zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
      zstyle ':completion:*' list-colors ''
      zstyle ':completion:*' max-errors 3 not-numeric

      export EDITOR=nvim

      # Honeyfetch no início do shell
      honeyfetch

      # Nix-shell integration
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
    '';

    oh-my-zsh = {
      enable  = true;
      theme   = "robbyrussell";
      plugins = [ "git" "z" "sudo" ];
    };

    enableCompletion    = true;
    autosuggestion.enable  = true;
    syntaxHighlighting.enable = true;
  };

  # ============================================
  # Neovim
  # ============================================
  programs.neovim = {
    enable       = true;
    defaultEditor = true;
    withNodeJs   = true;

    extraLuaConfig = ''
      -- Cores verdadeiras
      vim.opt.termguicolors = true

      -- Números de linha
      vim.opt.number         = true
      vim.opt.relativenumber = true
      vim.opt.cursorline     = true

      vim.api.nvim_set_hl(0, "LineNr",       { fg = "#505050" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFFF00", bold = true })

      -- Indentação
      vim.opt.tabstop     = 2
      vim.opt.shiftwidth  = 2
      vim.opt.expandtab   = true
      vim.opt.autoindent  = true
      vim.opt.smartindent = true

      -- Bootstrap lazy.nvim
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git", "clone", "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        -- Tema
        {
          "folke/tokyonight.nvim",
          lazy     = false,
          priority = 1000,
          config   = function()
            require("tokyonight").setup({
              style       = "night",
              transparent = false,
            })
          end,
        },

        -- Treesitter
        {
          "nvim-treesitter/nvim-treesitter",
          version = "0.9.3",
          build   = ":TSUpdate",
          config  = function()
            require("nvim-treesitter").setup({
              ensure_installed = {
                "c", "cpp", "lua", "python",
                "javascript", "typescript",
                "markdown", "sql", "bash",
                "html", "css", "json", "yaml", "rust",
              },
              auto_install  = true,
              sync_install  = false,
              highlight      = { enable = true },
              indent         = { enable = true },
            })
          end,
        },

        -- LSP
        {
          "neovim/nvim-lspconfig",
          config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local servers = {
              "clangd", "rust_analyzer", "ts_ls", "gopls", "jdtls",
            }
            for _, server in ipairs(servers) do
              vim.lsp.config(server, { capabilities = capabilities })
              vim.lsp.enable(server)
            end
          end,
        },

        -- Autocomplete
        {
          "hrsh7th/nvim-cmp",
          event        = { "InsertEnter", "CmdlineEnter" },
          dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
          },
          config = function()
            local cmp = require("cmp")
            cmp.setup({
              snippet = {
                expand = function(args)
                  vim.snippet.expand(args.body)
                end,
              },
              mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"]     = cmp.mapping.abort(),
                ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                ["<Tab>"]     = cmp.mapping.select_next_item(),
                ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
                ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
                ["<C-f>"]     = cmp.mapping.scroll_docs(4),
              }),
              sources = cmp.config.sources(
                { { name = "nvim_lsp" }, { name = "path" } },
                { { name = "buffer" } }
              ),
            })
            cmp.setup.cmdline({ "/", "?" }, {
              mapping = cmp.mapping.preset.cmdline(),
              sources = { { name = "buffer" } },
            })
            cmp.setup.cmdline(":", {
              mapping = cmp.mapping.preset.cmdline(),
              sources = cmp.config.sources(
                { { name = "path" } },
                { { name = "cmdline" } }
              ),
            })
          end,
        },
      })

      -- Aplica tema após plugins
      vim.cmd("colorscheme tokyonight")
    '';
  };

  programs.home-manager.enable = true;
}
