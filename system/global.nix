({ config, pkgs, ... }: {
  system.stateVersion = "25.05";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    cargo rustc just git vim wget gcc gnumake autoconf automake pkg-config cifs-utils
  ];
  programs.nixvim.enable = true;
  programs.nixvim.defaultEditor = true;
  security.sudo.wheelNeedsPassword = false;

  networking.networkmanager.enable = true;

  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.moonlight_stream.Moonlight"
  ];
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  time.timeZone = "Australia/Brisbane";
  users.users.aly = {
    isNormalUser = true;
    description = "aly";
    hashedPassword = "$y$j9T$Q.yFJjo9LMA8o.7Ac5uSr/$Y8pYIPSzCXHSd4nAlUohaaohwpquK6XEIjxFKq3J4s/";
    openssh.authorizedKeys.keys = import ../data/authorized_keys.nix;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = true; # disable password login
    };
    openFirewall = true;
  };
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
})
