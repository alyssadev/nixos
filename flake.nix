{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      aly-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hw-aly-laptop.nix
          ({ config, pkgs, ... }: {
            networking.hostName = "aly-laptop";
            services.logind = {
              lidSwitch = "suspend";
              lidSwitchDocked = "ignore";
              lidSwitchExternalPower = "ignore";
            };
          })
          ({ config, pkgs, ... }: {
            system.stateVersion = "25.05";
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            environment.systemPackages = with pkgs; [
              cargo rustc just git vim wget obs-studio gcc gnumake autoconf automake pkg-config
            ];
            environment.variables.EDITOR = "vim";
            security.sudo.wheelNeedsPassword = false;
          
            networking.networkmanager.enable = true;

            services.flatpak.enable = true;
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
              openssh.authorizedKeys.keys = import ./authorized_keys.nix;
              extraGroups = [ "networkmanager" "wheel" ];
            };
          
            # Enable the OpenSSH daemon.
            services.openssh = {
              enable = true;
              settings = {
                X11Forwarding = true;
                PermitRootLogin = "no"; # disable root login
                PasswordAuthentication = false; # disable password login
              };
              openFirewall = true;
            };
            # Enable the X11 windowing system.
            services.xserver.enable = true;
          
            # Enable the GNOME Desktop Environment.
            services.xserver.displayManager.gdm.enable = true;
            services.xserver.desktopManager.gnome.enable = true;
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.aly = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }

          ({ pkgs, ... }: {
            environment.etc."nixos".source = ./.;
          })
        ];
      };
    };
  };
}
