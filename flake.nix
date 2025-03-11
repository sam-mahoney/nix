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
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

     
    # NOTE `inputs.nixpkgs.follows` allows us to reuse an already defined input
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
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
	...
  } @ inputs: let
  	inherit (self) outputs;
  
  # Global user configuration
  users = {
    mahoney = {
      email = "mahoney@cmui.co.uk";
      fullName = "Sam Mahoney";
      name = "mahoney";
    };
  };

  # [!] Note, "${}" is used for string interpolation in nix
  #     Essentially, inserting vars or expressions inside strings

  # Function to generate system configuration with darwin & home-manager 
  mkDarwinConfiguration = hostname: user:
    # this fn is provided by nix-darwin to generate configurations
    darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      # These are additional arguments to pass to the configuration
      # 1. inherit inputs, outputs and hostname from the scope where the fn is called
      # 2. use the user config defined in the users attribute set defined above
      specialArgs = {
        inherit inputs outputs hostname;
        userConfig = users.${user};
        };
        # essentially imports, this fn generates a config from darwinsystem + modules
        modules = [
          ./machines/${hostname}
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
            ./machines/${hostname}/default.nix
            ];
          };

  # Function to generate Home Manager configuration
  mkHomeMgrConfiguration = hostname: user: system:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {inherit system;};
      # NOTE what is the difference between `specialArgs` & `extraSpecialArgs`? 
      # There isn't... nix-darwin and home-manager use different naming conventions
      # - `specialArgs` is uniq to nix-darwin,
      # - `extraSpecialArgs` is uniq to home-manager
      extraSpecialArgs = {
        inherit inputs outputs hostname;
        userConfig = users.${user};
        homemgrModules = "${self}/modules/home-manager";
      };
      modules = [
        ./homemgr/${user}/${hostname}
        # catppuccin.HomeManagerModules.catppuccin
      ];
    };
in {
  darwinConfigurations = {
    # Macbook Pro 16 | halcyon
    # Call fn with hostname, user, arch  
    "halcyon" = mkDarwinConfiguration "halcyon" "mahoney";
    "helios" = mkDarwinConfiguration "helios" "mahoney";
  };
#  nixosConfigurations = {
#    # TODO NixOS machine
#    "changeme" = mkNixosConfiguration "hostname" "user";
#  };
  homeConfigurations = {
    # MBP 16 (Personal)
    "mahoney@halcyon" = mkHomeMgrConfiguration "halcyon" "mahoney" "aarch64-darwin";
    # MBP 14 (Work)
    "mahoney@helios" = mkHomeMgrConfiguration "helios" "mahoney" "aarch64-darwin";
    # TODO NixOS
    };

  overlays = import ./overlays {inherit inputs;};
  };
}
