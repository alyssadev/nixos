{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-search = {
      url = "github:diamondburned/nix-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=v0.6.0";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-flatpak, nixos-generators, nur, nixvim, nix-search, ... }: {
    nixosConfigurations = {
      "aly-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nur.modules.nixos.default
          nix-flatpak.nixosModules.nix-flatpak
          nixvim.nixosModules.nixvim
          ./hw/aly-laptop.nix
          ./system/aly-laptop.nix
          ./system/global.nix
	  {
	    environment.systemPackages = [
	      nix-search.packages.x86_64-linux.default
	    ];
	  }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs.gui = true;
            home-manager.users.aly = import ./home/aly.nix;
	    home-manager.backupFileExtension = "bak";
          }
        ];
      };
      "aly-server" = nixpkgs.lib.nixosSystem {
      	system = "x86_64-linux";
	modules = [
          nur.modules.nixos.default
          nix-flatpak.nixosModules.nix-flatpak
          nixvim.nixosModules.nixvim
          ./hw/aly-server.nix
          ./system/aly-server.nix
	  {
	    environment.systemPackages = [
	      nix-search.packages.x86_64-linux.default
	    ];
	  }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs.gui = false;
            home-manager.users.aly = import ./home/aly.nix;
          }
          # TODO
	];
      };
    };
  };
}
