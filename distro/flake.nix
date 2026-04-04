{
  description = "FuzzyOS — An AI-first Linux distribution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # ── NixOS configuration ──────────────────────────────────────────
      nixosConfigurations.fuzzyos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs unstable; };
        modules = [
          ./configuration.nix
          ./modules/ai-layer.nix
          ./modules/branding.nix
          ./modules/desktop.nix
          ./modules/dev-tools.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.fuzzy = import ./home.nix;
          }
        ];
      };

      # ── Build targets ────────────────────────────────────────────────
      # Build ISO:  nix build .#iso
      # Build VM:   nix build .#vm
      packages.${system} = {
        iso = self.nixosConfigurations.fuzzyos.config.system.build.isoImage;
        vm = self.nixosConfigurations.fuzzyos.config.system.build.vm;
      };
    };
}
