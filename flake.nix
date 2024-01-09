{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      arch = "x86_64-darwin"; # or aarch64-darwin
	  system = "x86_64-darwin"; # or aarch64-darwin
      fzf-revision = import
        (builtins.fetchGit {
          name = "0.42.0";
          url = "https://github.com/NixOS/nixpkgs/";
          ref = "refs/heads/nixpkgs-unstable";
          rev = "9957cd48326fe8dbd52fdc50dd2502307f188b0d";
        })
        { inherit system; };

      pinned.fzf = fzf-revision.fzf;
    in
    {
      defaultPackage.${arch} =
        home-manager.defaultPackage.${arch};

      homeConfigurations."aleksandr.kirillov" =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${arch};
          modules = [ ./home.nix ];
          extraSpecialArgs = {
            pinned = pinned;
          };
        };
    };
}
