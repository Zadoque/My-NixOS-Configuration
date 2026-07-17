{ inputs, ... }:
{
  imports = [ inputs.zen-browser.homeModules.twilight ];

  programs.zen-browser = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "adguardadblocker@adguard.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/adguard-adblocker/latest.xpi";
          installation_mode = "normal_installed";
        };
        "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/video-downloadhelper/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };
  };
}
