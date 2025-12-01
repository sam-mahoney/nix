{ homemgrModules, ... }:{
  # TODO: work specific stuff
  imports = [
    "${homemgrModules}/common"
    "${homemgrModules}/ubuntu-common"
  ];

  # Enable Home Manager self-management
  programs.home-manager.enable = true;

  # State version
  home.stateVersion = "24.11";
}