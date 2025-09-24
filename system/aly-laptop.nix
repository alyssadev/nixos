({ config, pkgs, ... }: {
  networking.hostName = "aly-laptop";
  services.openvpn.servers = {
    laptop = { config = '' config /home/aly/.secrets/laptop.ovpn ''; };
  };
  fileSystems."/mnt/media" = {
    device = "//10.8.0.4/media";
    fsType = "cifs";
    options = ["x-systemd.requires=openvpn-laptop.service,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s"];
  };
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };
})
