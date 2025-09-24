{ config, pkgs, ... }:

{
  home.username = "aly";
  home.homeDirectory = "/home/aly";
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 300;
  };
  home.packages = with pkgs; [
    gnome-tweaks obs-studio rpi-imager google-cloud-sdk supersonic
    neofetch nnn zip xz unzip p7zip ripgrep jq yq-go mtr iperf3 dnsutils
    ldns aria2 socat nmap ipcalc file which tree gnused gnutar gawk zstd
    gnupg btop iotop iftop strace ltrace lsof sysstat lm_sensors ethtool
    pciutils usbutils nix-output-monitor
  ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin bitwarden darkreader indie-wiki-buddy sponsorblock
        ];
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "alydev";
    userEmail = "alyssa.dev.smith@gmail.com";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      alias vim='nvim'
    '';
  };
  home.stateVersion = "25.05";
}
