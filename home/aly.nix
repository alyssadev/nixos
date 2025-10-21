{ config, pkgs, lib, gui, ... }:

{
  home.username = "aly";
  home.homeDirectory = "/home/aly";
  xresources.properties = lib.mkIf gui {
    "Xcursor.size" = 16;
    "Xft.dpi" = 300;
  };
  home.packages = with pkgs; [
    neofetch nnn zip xz unzip p7zip ripgrep jq yq-go mtr iperf3 dnsutils
    ldns aria2 socat nmap ipcalc file which tree gnused gnutar gawk zstd
    gnupg btop iotop iftop strace ltrace lsof sysstat lm_sensors ethtool
    pciutils usbutils nix-output-monitor virtualenv python3 gh
  ] ++ lib.optionals gui [
    gnome-tweaks obs-studio rpi-imager google-cloud-sdk supersonic mpv
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
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
