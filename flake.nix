{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    vieb-nix = {
      url = "github:tejing1/vieb-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, vieb-nix, ... }@inputs:
    let
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    in
    {
      homeConfigurations = {
        gurathnaka = inputs.home-manager.lib.homeManagerConfiguration {
	  modules = [
	    {
              nixpkgs.overlays = overlays;
	    }
	  ];
	};
        slaanesh = inputs.home-manager.lib.homeManagerConfiguration {
	  modules = [
	    {
              nixpkgs.overlays = overlays;
	    }
	  ];
	};
      };
      nixosConfigurations = {
        gurathnaka = nixpkgs.lib.nixosSystem {
          modules = [
            ./hosts/gurathnaka.nix
            #./modules
  
            {nixpkgs.hostPlatform = "x86_64-linux";}
            {nixpkgs.config.allowUnfree = true;}
	    {nixpkgs.config.permittedInsecurePackages = [ "broadcom-sta-6.30.223.271-59-6.18.5" ];}
  
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
              home-manager.backupFileExtension  = "backup";
            }
          ];
          specialArgs = {inherit inputs;};
        };
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
