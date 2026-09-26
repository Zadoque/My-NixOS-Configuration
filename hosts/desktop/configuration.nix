{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../intel.nix
  ];

  networking.hostName = "desktop-nixos";

  # Permite que o usuário dock controle a inibição de suspensão pela sessão.
  # Não cria máscaras globais nem altera outros usuários/hosts.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.user == "dock" &&
          subject.active == true &&
          (action.id == "org.freedesktop.login1.hibernate" ||
           action.id == "org.freedesktop.login1.suspend" ||
           action.id == "org.freedesktop.login1 hybrid-sleep" ||
           action.id == "org.freedesktop.login1.sleep")) {
        return polkit.Result.YES;
      }
    });
  '';
}