{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "aarch64-darwin";
      fzf.pkgs = import (builtins.fetchGit {
        name = "0.42.0";
        url = "https://github.com/NixOS/nixpkgs/";
        ref = "refs/heads/nixpkgs-unstable";
        rev = "9957cd48326fe8dbd52fdc50dd2502307f188b0d";
      }) { inherit system; };

      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      pinned = { fzf = fzf.pkgs.fzf; };
    in {
      defaultPackage.${system} = home-manager.defaultPackage.${system};

      homeConfigurations."aleksandr.kirillov" =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            pinned = pinned;
            pkgs-unstable = pkgs-unstable;
          };
        };
    };
}
