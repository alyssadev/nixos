({ config, pkgs, agenix, ... }: {
  networking.hostName = "aly-server";
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

  networking.networkmanager.enable = true;

  time.timeZone = "Australia/Brisbane";
  users.users.aly = {
    isNormalUser = true;
    description = "aly";
    hashedPassword = "$y$j9T$Q.yFJjo9LMA8o.7Ac5uSr/$Y8pYIPSzCXHSd4nAlUohaaohwpquK6XEIjxFKq3J4s/";
    openssh.authorizedKeys.keys = import ../data/authorized_keys.nix;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

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
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
	"server string" = "aly-server";
	"netbios name" = "aly-server";
	"security" = "user";
	"max protocol" = "smb1";
	"hosts allow" = "192.168.0. 10.8.0. localhost 127.0.0.1";
	"hosts deny" = "0.0.0.0/0";
	"guest account" = "nobody";
	"map to guest" = "bad user";
      };
      "storage" = {
        "path" = "/mnt/storage";
	"browseable" = "yes";
	"read only" = "no";
	"guest ok" = "no";
	"create mask" = "0664";
        "directory mask" = "0775";
	"force user" = "1001";
	"force group" = "1005";
      };
      "media" = {
        "path" = "/mnt/storage/media";
	"browseable" = "yes";
	"read only" = "yes";
	"guest ok" = "yes";
      };
    };
  };
})
