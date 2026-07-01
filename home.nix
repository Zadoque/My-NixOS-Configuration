{ config, pkgs, inputs, ... }:

{
  home.username = "dock";
  home.homeDirectory = "/home/dock";
  home.stateVersion = "23.11"; 

  # 1. Pacotes instalados diretamente
  home.packages = with pkgs; [
    nitrogen
    home-manager.extraSpecialArgs = { inherit inputs; };
    # Outros pacotes do seu usuário virão para cá depois
  ];

  # 2. Configuração do Picom 🪟
  services.picom = {
    enable = true;
    # Mais tarde podemos adicionar sombras, opacidade, etc. aqui.
  };

  # 3. Configuração do i3 🖥️
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;
    # Aqui poderemos definir atalhos, barras e cores depois
  };

  programs.home-manager.enable = true;
}
