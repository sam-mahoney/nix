{ 
  pkgs,
  outputs,
  userConfig,
  ...
}: {

  # nix configuration
  # -----------------

  nixpkgs = {
    config = {
      allowUnfree = true; # allow non-opensource pkgs
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true; # replaces identical files in the store with hard links
    };
    package = pkgs.nix;
    optimise.automatic = true;
  };

  services.nix-daemon.enable = true;

  users.user.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };

  # sudo auth with TouchID
  security.pam.enableSudoTouchIdAuth = true;
  
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
        ShowDate = true;
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
        AppleCUForce24HourTime = true;
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
        Bluetooth = 18; # 18 = Show
        Display = 18;
        NowPlaying = 24; # 24 = Hide
        Sound = 18;
      };
      screencapture = {
        location = "/Users/${userConfig.name}/Downloads/screencaps";
        type = "png";
        disable-shadow = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
    };
    WindowManager.EnableStandardClickToShowDesktop = false;
    screensaver.AskForPassword = true;
  };


  # Packages
#  environment.systemPackages = with pkgs; [
#    fd
#    jq
#    ripgrep
#  ];

  # TODO: zsh config 
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableFzfCompletion = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
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
      "hammerspoon"
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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
