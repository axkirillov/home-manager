Here I try to keep track of all my dev tools configs.

The main tool used for this purpose is [home-manager](https://github.com/nix-community/home-manager)

Home manager requires [nix](https://nixos.org/download/) to be installed

I use nix [flakes](https://nixos.wiki/wiki/Flakes), because it's the declarative and modern way to use nix.

The entrypoint to the configuration is the [flake.nix](https://github.com/axkirillov/home-manager/blob/main/flake.nix) file

Flakes allow me to do fancy things like [pinning](https://github.com/axkirillov/home-manager/blob/fada82c762a4cff8dc8749c3dcf41ad6cf7f70d0/flake.nix#L15) certain packages.

Most of the configuration, however happens in the [home.nix](https://github.com/axkirillov/home-manager/blob/main/home.nix) file

The command to install the configuration is
```
home-manager switch
```
The command to update packages is
```
nix flake update
```
To check for package names use https://search.nixos.org/packages

To check for home-manager package options see https://home-manager-options.extranix.com

To pin a version use this guide https://lazamar.co.uk/nix-versions/
