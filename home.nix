{ config, pkgs, ... }:

{
  home.username = "aly";
  home.homeDirectory = "/home/aly";
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };
  home.packages = with pkgs; [
    gnome-tweaks
    firefox
    neofetch
    nnn
    zip
    xz
    unzip
    p7zip
    ripgrep
    jq
    yq-go
    mtr
    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    nix-output-monitor

    btop
    iotop
    iftop
    strace
    ltrace
    lsof
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
  ];
  programs.git = {
    enable = true;
    userName = "alydev";
    userEmail = "alyssa.dev.smith@gmail.com";
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
#  programs.alacritty = {
#    enable = true;
#    # custom settings
#    settings = {
#      env.TERM = "xterm-256color";
#      font = {
#        size = 12;
#        draw_bold_text_with_bright_colors = true;
#      };
#      scrolling.multiplier = 5;
#      selection.save_to_clipboard = true;
#    };
#  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
  };
  home.stateVersion = "25.05";
}
