{
  description = "Foundry: flake to configure nix-darwin & NixOS";
 
  inputs = {

    # nixpkgs
    # -------
    # nixpkgs-<version>-darwin : stable branch, specifically for darwin systems
    # nixos-<version>          : stable branch, mixed environments (NixOS & darwin)
    # nixpkgs-unstable         : less stable, cutting-edge branch

    # https://discourse.nixos.org/t/differences-between-nix-channels/13998
    
    # NOTE as of 29/12/2024, 24.11 is the latest release
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

     
    # NOTE `inputs.nixpkgs.follows` allows us to reuse an already defined input
    darwin = {
	url = "github:LnL7/nix-darwin";
	inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  
    # home-manager for cross-platform user configuration
    home-manager = {
	url = "github:nix-community/home-manager";
	inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # TODO global theme?
    # catppuccin.url = "github:catppuccin/nix"

  };

  # outputs
  # -------
  # quite literally defines the outputs of this flake
  
  # notes on defining the output function...

  # - `self` is the current flake object, allowing self reference

  # - defines specific inputs (self, darwin, home-manager) from the inputs set
  # - `...` allows additional inputs which haven't been explicitly defined
  # - `@inputs` ensures the entire inputs set is avaliable 

  # - `let inherit (self) outputs;` binds outputs to self.outputs (quality of life)
  outputs = {
	self,
	darwin,
	home-manager,
	nixpkgs,
	nixpkgs-darwin,
	...
  } @ inputs: let
  	inherit (self) outputs;
  
  # Global user configuration
  users = {
    mahoney = {
      email = "mahoney@cmui.co.uk";
      name = "mahoney";
    };
  };

  # Function to generate system configuration with darwin & home-manager 
  mkDarwinConfiguration = hostname: user: arch ? "aarch64-darwin":
    # this fn is provided by nix-darwin to generate configurations
    darwin.lib.darwinsystem {
      system = arch;
      # These are additional arguments to pass to the configuration
      # 1. inherit inputs, outputs and hostname from the scope where the fn is called
      # 2. use the user config defined in the users attribute set defined above
      specialArgs = {
        inherit inputs outputs hostname;
	userConfig = users.${user};
      };
      # essentially imports, this fn generates a config from darwinsystem + modules
      modules = [
        ./hosts/${hostname}/configuration.nix
	home-manager.darwinModules.home-manager
      ];
    };

  # TODO Function to generate NixOS system configuration
  mkNixosConfiguration = hostname: user:
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs hostname;
	userConfig = users.${user};
      };
      modules = [
        ./hosts/${hostname}/configuration.nix
      ];
    };

  # Function to generate Home Manager configuration
  mkHomeMgrConfiguration = hostname: user: arch:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = arch;
      };
      # NOTE what is the difference between `specialArgs` & `extraSpecialArgs`? 
      # There isn't... nix-darwin and home-manager use different naming conventions
      # - `specialArgs` is uniq to nix-darwin,
      # - `extraSpecialArgs` is uniq to home-manager
      extraSpecialArgs = {
        inherit inputs outputs;
	userConfig = users.${user};
      };
      modules = [
        ./home/${user}/${hostname}.nix
	# catppuccin.HomeManagerModules.catppuccin
      ];
    };
in {
  
  darwinConfigurations = {
    # Macbook Pro 16 
    "halcyon" = mkDarwinConfiguration "halcyon" "mahoney" "aarch64-darwin";
  };
  
  nixosConfigurations = {
    # TODO NixOS machine
    "changeme" = mkNixosConfiguration "hostname" "user";
  };

  homeMgrConfigurations = {
    "mahoney@halcyon" = mkHomeMgrConfiguration "halcyon" "mahoney" "aarch64-darwin";
    # TODO nixOS
  };
};

