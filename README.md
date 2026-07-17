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
