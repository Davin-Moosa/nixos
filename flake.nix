{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ ... }: {
    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        (
          { pkgs, ... }:
          {
            nixpkgs.overlays = [
              inputs.neovim-nightly-overlay.overlays.default
              inputs.nix-cachyos-kernel.overlays.default
            ];

            nix.settings = {
              substituters = [
                "https://attic.xuyh0120.win/lantian"
                "https://nix-community.cachix.org"
              ];
              trusted-public-keys = [
                "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              ];
            };

            boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;

            environment.systemPackages = [
              inputs.helium.packages.${pkgs.stdenv.system}.default
            ];
          }
        )
      ];
    };
  };
}
