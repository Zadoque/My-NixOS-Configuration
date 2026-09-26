{
  description = "Configuração NixOS multi-host e multi-usuário com Home Manager e Zen Browser";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }@inputs:
  let
    mkHost = hostPath: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        hostPath
        ./common.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dock = import ./home/zadoque/home.nix;
          home-manager.users.natalia = import ./home/esposa/home.nix;
        }
      ];
    };
  in {
    nixosConfigurations = {
      desktop = mkHost ./hosts/desktop/configuration.nix;
      notebook = mkHost ./hosts/notebook/configuration.nix;
    };
  };
}
