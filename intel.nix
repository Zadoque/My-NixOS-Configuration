{ pkgs, ... }:
{
  boot.kernelParams = [ "i915.modeset=1" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      libvdpau-va-gl
    ];
  };
}
