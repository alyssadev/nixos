({ config, pkgs, ... }: {
  networking.hostName = "aly-laptop";
  services.openvpn.servers = {
    laptop = { config = '' config /home/aly/.secrets/laptop.ovpn ''; };
  };
  fileSystems."/mnt/media" = {
    device = "//10.8.0.4/media";
    fsType = "cifs";
    options = ["ro,guest,vers=3.0,x-systemd.requires=openvpn-laptop.service,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"];
  };
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
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
