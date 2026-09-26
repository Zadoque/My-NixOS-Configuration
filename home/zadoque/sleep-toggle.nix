{ config, pkgs, ... }:

let
  # systemd-inhibit só executa este programa depois de adquirir o bloqueio.
  # Type=notify faz o toggle aguardar essa confirmação antes de anunciar sucesso.
  holdInhibit = pkgs.writeShellScript "hold-sleep-inhibit" ''
    set -euo pipefail
    ${pkgs.systemd}/bin/systemd-notify --ready
    exec ${pkgs.coreutils}/bin/sleep infinity
  '';

  toggleSleep = pkgs.writeShellApplication {
    name = "toggle-sleep-inhibit";
    runtimeInputs = [ pkgs.systemd pkgs.util-linux pkgs.libnotify ];
    text = ''
      unit="sleep-inhibit.service"

      notify() {
        notify-send "Suspensão" "$1" || true
      }

      # Ignora acionamentos simultâneos enquanto uma operação está em curso.
      # O serviço é identificado pelo systemd, sem PID salvo que possa ser reutilizado.
      exec 9>"''${XDG_RUNTIME_DIR:?Sessão de usuário indisponível}/sleep-inhibit-toggle.lock"
      flock --nonblock 9 || exit 0

      if systemctl --user is-active --quiet "$unit"; then
        if systemctl --user stop "$unit"; then
          notify "Bloqueio deste toggle DESATIVADO."
        else
          notify "Não foi possível desativar o bloqueio. Consulte o journal do serviço."
          exit 1
        fi
      else
        if systemctl --user start "$unit"; then
          notify "Suspensão e hibernação BLOQUEADAS enquanto esta sessão estiver aberta."
        else
          notify "Não foi possível bloquear a suspensão. Consulte o journal do serviço."
          exit 1
        fi
      fi
    '';
  };
in
{
  home.packages = [ toggleSleep ];

  # Sem WantedBy: começa desligado e só é iniciado pelo toggle.
  # O inibidor pertence a este usuário, mas mantém a máquina inteira acordada.
  systemd.user.services.sleep-inhibit = {
    Unit = {
      Description = "Bloqueio manual de suspensão e hibernação";
      Requisite = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "${pkgs.systemd}/bin/systemd-inhibit --what=sleep:idle --mode=block --who=${config.home.username}-desktop --why=\"Toggle manual de suspensão\" ${holdInhibit}";
      TimeoutStartSec = 10;
      KillMode = "control-group";
    };
  };

  xsession.windowManager.i3.config.keybindings = {
    "${config.xsession.windowManager.i3.config.modifier}+Shift+s" =
      "exec --no-startup-id ${toggleSleep}/bin/toggle-sleep-inhibit";
  };
}
