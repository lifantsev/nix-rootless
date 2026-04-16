{
    description = "Mark Lifantsev's personal home manager configuration to use on rootless servers";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

        home-manager.url = "github:nix-community/home-manager/release-25.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # lifantsev-nixvim.url = "github:lifantsev/nixvim";
    };

    outputs = { nixpkgs, home-manager, ... }@inputs: let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in {
        homeConfigurations."marklif" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = { inherit inputs; };
            modules = [ ./home ];
        };
    };
}
