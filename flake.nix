{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      arch = "x86_64-darwin"; # or aarch64-darwin
    in
    {
      defaultPackage.${arch} =
        home-manager.defaultPackage.${arch};

      homeConfigurations."aleksandr.kirillov" =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${arch};
          modules = [ ./home.nix ];
        };
    };
}
