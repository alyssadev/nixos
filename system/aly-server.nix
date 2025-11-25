({ config, pkgs, agenix, ... }: {
  networking.hostName = "aly-server";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    80 443 445 3923 5656 5030 5031 50300
    4747 8989 7878 8686 13378 6767 9696 4545
    52568 50000
  ];
  networking.firewall.allowedUDPPorts = [
    137 138 139 50000 
  ];
  services.openvpn.servers = {
    server = { config = '' config /home/aly/.secrets/server.ovpn ''; };
  };
  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 * * * * /mnt/storage/media/randomintro.sh"
      "* * * * * sudo chown srv:media /mnt/storage/media/downloads -R; sudo chmod g+w /mnt/storage/media/downloads -R"
    ];
  };
  system.stateVersion = "25.05";
  virtualisation.hypervGuest.enable = true;
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";
  boot.blacklistedKernelModules = [ "hyperv_fb" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    cargo rustc just git wget gcc gnumake autoconf automake pkg-config cifs-utils btrfs-progs
  ];
  programs.nixvim.enable = true;
  programs.nixvim.defaultEditor = true;
  security.sudo.wheelNeedsPassword = false;

  time.timeZone = "Australia/Brisbane";
  users.users.aly = {
    isNormalUser = true;
    description = "aly";
    hashedPassword = "$y$j9T$Q.yFJjo9LMA8o.7Ac5uSr/$Y8pYIPSzCXHSd4nAlUohaaohwpquK6XEIjxFKq3J4s/";
    openssh.authorizedKeys.keys = import ../data/authorized_keys.nix;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

#  services.smartd = {
#    enable = true;
#    devices = [
#      {
#        device = "/dev/disk/by-id/scsi-350014e2eb8b19461";
#      }
#      {
#        device = "/dev/disk/by-id/scsi-35000cc2a5cce6c33";
#      }
#      {
#        device = "/dev/disk/by-id/scsi-35000c500db1f5eb8";
#      }
#    ];
#  };

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
    openFirewall = true;
  };

  services.samba-wsdd.enable = true;
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
	"server string" = "aly-server";
	"netbios name" = "aly-server";
	"disable netbios" = "yes";
	"wide links" = "yes";
	"allow insecure wide links" = "yes";
	"security" = "user";
	"min protocol" = "SMB2_02";
	"max protocol" = "SMB3_11";
	"hosts allow" = "192.168.0. 10.8.0. localhost 127.0.0.1";
	"hosts deny" = "0.0.0.0/0";
	"guest account" = "nobody";
	"map to guest" = "bad user";
	"interfaces" = "lo eth0 docker0 tun0";
	"bind interfaces only" = "yes";
      };
      "storage" = {
        "path" = "/mnt/storage";
	"browseable" = "yes";
	"read only" = "no";
	"guest ok" = "no";
	"guest only" = "no";
	"inherit acls" = "no";
	"inherit permissions" = "no";
	"store dos attributes" = "no";
	"follow symlinks" = "yes";
	"valid users" = "aly";
	"create mask" = "0664";
        "directory mask" = "0775";
      };
      "media" = {
        "path" = "/mnt/storage/media";
	"browseable" = "yes";
	"read only" = "yes";
	"guest ok" = "yes";
	"hide special files" = "yes";
	"inherit acls" = "no";
	"inherit permissions" = "no";
	"store dos attributes" = "no";
	"follow symlinks" = "yes";
      };
      "mirror" = {
        "path" = "/mnt/storage/mirror";
	"browseable" = "yes";
	"read only" = "yes";
	"guest ok" = "yes";
	"hide special files" = "yes";
	"inherit acls" = "no";
	"inherit permissions" = "no";
	"store dos attributes" = "no";
	"follow symlinks" = "yes";
      };
    };
  };
})
