# Start of the Main Flake

{
  description = "Nix-Core Infratructure";
  # External Dependicies Inputs
  # Standard NixOs Packages
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixvirt.url = "github:AshleyYakeley/NixVirt";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User-level Configuration Tool, Keep HomeManager on same version as system
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # What this flake produces Outputs
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      nixvirt,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        gbook = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/gbook/galaxy.nix
            home-manager.nixosModules.home-manager
            nixvirt.nixosModules.default
          ];

        };
        bootstrap = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            disko.nixosModules.disko
            ./boot-strap/strap.nix
          ];
        };
        droplet = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/droplet/cloud-core.nix
            home-manager.nixosModules.home-manager
          ];
        };
        sr250 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/sr250/sr250serv.nix
            home-manager.nixosModules.home-manager
          ];
        };
        m910q = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/m910q/m910q.nix
            home-manager.nixosModules.home-manager
          ];
        };

      };
    };
}
