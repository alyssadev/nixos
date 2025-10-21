({ config, pkgs, ... }: {
  networking.hostName = "aly-laptop";
  services.openvpn.servers = {
    laptop = { config = '' config /home/aly/.secrets/laptop.ovpn ''; };
  };
  fileSystems."/mnt/storage" = {
    device = "aly@vpn.aly.pet:/mnt/storage";
    fsType = "sshfs";
    options = ["nodev,noatime,allow_other,IdentityFile=/home/aly/.ssh/id_ed25519"];
  };
  programs.firefox = {
    enable = true;
  };
  services.gnome = {
    gnome-browser-connector.enable = true;
  };
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    powerKey = "ignore";
  };
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.moonlight_stream.Moonlight"
  ];
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
})
