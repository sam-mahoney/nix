{
  outputs,
  userConfig,
  pkgs,
  ...
}: 
{
  # stuff with additional config
  imports = [
    ../programs/alacritty
    ../programs/atuin
    ../programs/bat
    ../programs/fzf
    ../programs/git
    ../programs/go
    ../programs/gpg
    ../programs/neovim
    ../programs/tmux
    ../programs/starship
    ../programs/zsh
    # ../programs/vscode
    ../programs/fastfetch
    ../scripts
  ];

  # Nixpkgs configuration
  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "${userConfig.name}";
    homeDirectory = 
      if pkgs.stdenv.isDarwin # MacOS vs NixOS
      then "/Users/${userConfig.name}"
      else "/home/${userConfig.name}";
  };

  # Install common packages
  home.packages = with pkgs;
    [
      # 1password currently broken on nix-darwin | installed with brew
      # _1password
      # _1password-gui
      anki-bin
      # firefox # ^^
      # https://nixos.wiki/wiki/Logseq | installed with brew
      # aerospace | brew vs nixpkgs:unstable
      dig
      fd
      ripgrep
      jq
      gh
      python3
      poetry
      tor
      nh
      awscli2
      eza
      du-dust
      vscode
      wget
      nmap
      # Beacon Stuff
      ssm-session-manager-plugin
      azure-cli
      #vagrant # currently breaks build
      keybase
      ctags
    ]
    ++ lib.optionals stdenv.isDarwin [
      findutils
      iina
      hidden-bar
      colima # Run docker on MacOS (w/o Docker Desktop) using Lima, a minimal Linux VM
      docker
    ];

    # TODO Theme?
    #catppuccin = {
    #  flavor = "macchiato";
    #  accent = "lavender";
    # };
}
