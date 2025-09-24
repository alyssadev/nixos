{ config, pkgs, ... }:

{
  home.username = "aly";
  home.homeDirectory = "/home/aly";
  services.flatpak.packages = [
    "com.moonlight_stream.Moonlight"
  ];
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  home.packages = with pkgs; [
    gnome-tweaks firefox obs-studio rpi-imager
    neofetch nnn zip xz unzip p7zip ripgrep jq yq-go mtr iperf3 dnsutils
    ldns aria2 socat nmap ipcalc file which tree gnused gnutar gawk zstd
    gnupg btop iotop iftop strace ltrace lsof sysstat lm_sensors ethtool
    pciutils usbutils nix-output-monitor
  ];
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
    '';
  };
  home.stateVersion = "25.05";
}
