{ 
  pkgs,
  outputs,
  userConfig,
  ...
}: {

  # nix configuration
  # -----------------

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true; # allow non-opensource pkgs
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    package = pkgs.nix;
    optimise.automatic = true;
  };

  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  # sudo auth with TouchID
  security.pam.services.sudo_local.touchIdAuth = true;
  
  # System settings
  # ---------------
  # nix-darwin options: https://mynixos.com/nix-darwin/options/system
  # *Incomplete* list of macOS defaults: https://macos-defaults.com/
  system = {
    defaults = {
      CustomUserPreferences = {
        NSGlobalDomain."com.apple.mouse.linear" = true;
      };
      # Tick, Tock 
      menuExtraClock = {
        IsAnalog = true;
        ShowDate = 0;
      };
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        PMPrintingExpandedStateForPrint = true;
      };
      LaunchServices = {
        LSQuarantine = false;
      };
      trackpad = {
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        Clicking = true;
      };
      finder = {
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf"; # "SCcf" = current folder
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv"; # "clmv" = column view
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
        _FXSortFoldersFirst = true;
      };
      dock = {
        autohide = true;
        orientation = "left";
        autohide-delay = 0.15;
        expose-animation-duration = 0.15;
        show-recents = false;
        showhidden = true;
        persistent-apps = [];
        tilesize = 56;
        # disable "hot corner" actions
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
      };
      controlcenter = {
        BatteryShowPercentage = true;
        Bluetooth = true;
        Display = true;
        NowPlaying = false;
        Sound = true;
      };
      screencapture = {
        location = "/Users/${userConfig.name}/Downloads/screencaps";
        type = "png";
        disable-shadow = true;
      };
    WindowManager.EnableStandardClickToShowDesktop = false;
    screensaver.askForPassword = true;
    };
    keyboard = {
      enableKeyMapping = true;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      # Builds will NOT be idempotent due to these options - but they enable better QOL
      autoUpdate = true; # Auto-update homebrew and all formulae
      upgrade = true; # upgrade outdated formulae & Mac App Store
    };
    brews = [
      "mas" # Mac App Store CLI
      "wimlib" # windows imaging lib: https://wimlib.net/
    ];
    casks = [
      "1password"
      "hammerspoon"
      "logseq"
      "anytype"
      "notion"
      "the-unarchiver"
      "nikitabobka/tap/aerospace"
      "balenaetcher"
      "cold-turkey-blocker"
    ];
    taps = [
      "nikitabobko/tap"
    ];
    masApps = {};
  };
 
  # https://github.com/elliottminns/dotfiles/blob/main/nix/darwin/flake.nix#L110C1-L128C12	
  # system.activationScripts.applications.text = let
    # env = pkgs.buildEnv {
      # name = "system-applications";
      # paths = config.environment.systemPackages;
      # pathsToLink = "/Applications";
    # };
  # in
    # pkgs.lib.mkForce ''
      # # Set up applications.
      # echo "setting up /Applications..." >&2
      # rm -rf /Applications/Nix\ Apps
      # mkdir -p /Applications/Nix\ Apps
      # find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      # while read -r src; do
      # app_name=$(basename "$src")
      # echo "copying $src" >&2
      # ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      # done
    # '';	

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
