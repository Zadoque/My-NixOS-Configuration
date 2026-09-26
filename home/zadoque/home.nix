{ config, lib, pkgs, ... }:

{
  # ... seu conteúdo atual do home.nix ...

  # Adicionar opção de power management
  powermanagement = {
    disableSuspend = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "When true, prevent the system from suspending/hibernating";
    };
  };

  # Definir o valor do toggle (mude para true/false conforme necessário)
  powermanagement.disableSuspend = false;

  # ... resto do seu home.nix ...
}