{
  description = "Nix Setting!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }: {
    homeConfigurations."hoge" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit self; };
      modules = [
        ./users/default.nix
        ./secrets
        sops-nix.homeManagerModules.sops
      ];
    };

    modules = {
      my-common-module = import ./modules/default.nix;
    };

    packages.x86_64-linux = import ./packages {
      inherit nixpkgs;
      system = "x86_64-linux";
    };
    packages.aarch64-darwin = import ./packages {
      inherit nixpkgs;
      system = "aarch64-darwin";
    };
  };
}
