{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "desktop-nss";

  # O desktop NSS usa a iGPU AMD Radeon do Ryzen 5 5600GT.
  # O stack Mesa/AMDGPU fornecido pelo NixOS não precisa dos
  # pacotes Intel presentes no módulo ../../intel.nix do host desktop.
  hardware.graphics.enable = true;
}
