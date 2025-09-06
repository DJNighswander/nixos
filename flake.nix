{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
    }: {
    nixosConfigurations = {
      slaanesh = nixpkgs.lib.nixosSystem {
        modules = [
	  ./hosts/slaanesh.nix
	  #./modules

	  {nixpkgs.hostPlatform = "x86_64-linux";}
	  {nixpkgs.config.allowUnfree = true;}

	  ({ pkgs, ... }: {
	    nix = {
	      registry = {
               nixpkgs.flake = nixpkgs;
	      };
	    };
	  })

	  home-manager.nixosModules.home-manager
	  {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.djnighs = import ./home-manager/default.nix;
	    home-manager.extraSpecialArgs = {inherit inputs;};
	    home-manager.backupFileExtension  = "hm-backup";
	  }
	];
	specialArgs = {inherit inputs;};
      };
    };
  };
}
