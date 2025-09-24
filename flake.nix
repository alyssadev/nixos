{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      "aly-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hw/aly-laptop.nix
          ./system/aly-laptop.nix
          ./system/global.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.aly = import ./home/aly.nix;
          }
        ];
      };
    };
  };
}
