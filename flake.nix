{
  description = "Sam's nix-darwin system flake";
 
  inputs = {
    # I had to pin darwin as it was breaking my builds
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable }:
  let
    # configuration is a fn which defines the system configuration 
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
	  pkgs.vim
	  pkgs.neovim
	  pkgs.fzf
	  pkgs.tmux
	  pkgs.mkalias
	  pkgs.gh
	  pkgs.git
  	  pkgs.gnupg
	  pkgs.ripgrep
	  pkgs.tldr
	  # python dev tools
	  pkgs.poetry
	  # gui apps
	  pkgs.alacritty
	  pkgs.vscode
        ];

  	fonts.packages = with pkgs; [
    	  (nerdfonts.override {fonts = ["Meslo" "JetBrainsMono"];})
    	  roboto
  	];

      homebrew = {
        enable = true;
   	onActivation = {
	  cleanup = "zap";
	  # Builds will NOT be idempotent due to these options - but better qol
	  autoUpdate = true; # Auto-update Homebrew and all formulae
	  upgrade = true; # upgrade outdated formulae & Mac App Store
	};
      	brews = [
	  "mas"
	  "wimlib"
	];
	casks = [
	  "1password"
	  "hammerspoon"
	  "logseq"
	  "notion"
	  "firefox"
	  "iina"
	  "the-unarchiver"
	  "spotify"
	  "nikitabobko/tap/aerospace"
	  "anki"
	  "balenaetcher"
	];
	taps = [
	  "nikitabobko/tap"
	];
	masApps = {
	};
      };

      # MacOS settings
      system.defaults = {
        dock = {
          autohide = true;
	  autohide-delay = 0.1;
	  orientation = "left";
	  show-process-indicators = false;
	  show-recents = false;
	  tilesize = 56;
	  # static-only = true;
	  # Define persistent apps in the dock as a list of strings (path)
	  # persistent-apps = [];
	};

	finder = {
	  AppleShowAllExtensions = true;
	  ShowPathbar = true;
	  FXEnableExtensionChangeWarning = false;
	};
	
	trackpad.TrackpadRightClick = true;	
	WindowManager.EnableStandardClickToShowDesktop = false;
	
      };
     
      security.pam.enableSudoTouchIdAuth = true;

      # https://github.com/elliottminns/dotfiles/blob/main/nix/darwin/flake.nix#L110C1-L128C12	
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';	


      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads nix-darwin env
      programs.zsh = {
      	enable = true;
	enableCompletion = true;
        enableFzfCompletion = true;
	enableFzfHistory = true;
	enableSyntaxHighlighting = true;
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.mahoney = {
	name = "mahoney";
	home = "/Users/mahoney";
      };

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mbpro16
    darwinConfigurations."mbpro16" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mbpro16".pkgs;
  };
}
