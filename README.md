# My-NixOS-Configuration

Estrutura multi-host e multi-usuário com flakes, Home Manager e Zen Browser.

## Estrutura

- `hosts/desktop/`: configuração do computador
- `hosts/notebook/`: configuração do notebook
- `home/zadoque/`: perfil do usuário dock
- `home/esposa/`: perfil do usuário natalia
- `home/zen-common.nix`: configuração compartilhada do Zen Browser
- `intel.nix`: ajustes comuns de vídeo Intel

## Antes do rebuild

Copie o arquivo gerado pela instalação para cada host:

```bash
cp /etc/nixos/hardware-configuration.nix ~/My-NixOS-Configuration/hosts/notebook/
cp /etc/nixos/hardware-configuration.nix ~/My-NixOS-Configuration/hosts/desktop/
```

Faça isso em cada máquina, copiando o arquivo correto da própria máquina.

## Rebuild com flakes

No desktop:

```bash
sudo nixos-rebuild switch --flake /home/dock/My-NixOS-Configuration#desktop
```

No notebook:

```bash
sudo nixos-rebuild switch --flake /home/dock/My-NixOS-Configuration#notebook
```

## Observações

Os add-ons do Zen Browser foram configurados declarativamente para os dois usuários via Home Manager.
Os Zen Mods e o tema visual fino do Zen ainda podem exigir ajuste manual dentro do perfil do navegador.

## Toggle de suspensão no desktop

No i3, **Alt+Shift+S** liga/desliga o bloqueio de suspensão e hibernação.
Também é possível executar `toggle-sleep-inhibit` em um terminal da sessão gráfica.
O módulo é importado apenas em `hosts/desktop/configuration.nix`, para o usuário
`dock` (Zadoque). Não é instalado no notebook nem no perfil de `natalia`.

O toggle começa desligado, não exige `sudo` e é encerrado ao sair da sessão gráfica.
Ele usa um serviço de usuário com um inibidor `sleep:idle` do logind, que cobre
suspensão, hibernação e ações automáticas por inatividade. Enquanto estiver ativo,
o bloqueio vale para o computador inteiro, inclusive se outro usuário abrir uma
sessão simultânea. Bloquear a tela ou trocar de usuário não encerra sua sessão.
Não modifica o bloqueio/apagamento da tela nem impede desligamento e reinicialização
explícitos. Operações privilegiadas que ignoram inibidores podem ultrapassar o bloqueio.

Para aplicar no desktop, primeiro valide a construção e depois ative:

```bash
sudo nixos-rebuild build --flake .#desktop
sudo nixos-rebuild switch --flake .#desktop
i3-msg reload
```

Para conferir o estado após acionar o atalho:

```bash
systemctl --user status sleep-inhibit.service
systemd-inhibit --list
```

Quando ligado, procure um inibidor `dock-desktop` com `sleep:idle` e modo `block`.
Ao desligar, esse inibidor deve desaparecer; outros inibidores podem continuar ativos.
Se houver erro, consulte `journalctl --user -u sleep-inhibit.service -b`.
A notificação de ativação só é enviada depois de o serviço adquirir o inibidor;
uma falha nas notificações não impede o funcionamento do toggle.
