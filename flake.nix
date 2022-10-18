{
  description = "My first nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, home-manager, darwin, nixos-generators, ... }: {

    # packages.x86_64-linux = {
    #   vmware = nixos-generators.nixosGenerate {
    #     system = "x86_64-linux";
    #     modules = [
    #     ];
    #     format = "vmware";
    #   };
    # };

    darwinConfigurations."pavel-mbp18" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        ./hosts/pavel-mbp18/default.nix
      ];
    };

  };
}
