{
  description = "Zadoque's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          specialArgs = { inherit pkgs; };
          modules = [
            ./hosts/desktop/configuration.nix
            ./common.nix

            # Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zadoque = import ./home/zadoque/home.nix;

              # Garantir que a opção do home-manager esteja disponível no NixOS
              home-manager.extraSpecialArgs = { inherit pkgs; };
            }
          ];
        };
      };
    };
}