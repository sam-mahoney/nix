{homemgrModules, ...}: {
  # `import` will load and evaluate another Nix expression from a file.
  # [!] When a dir is imported, dir/default.nix is loaded and evaluated
  imports = [
    "${homemgrModules}/common"
    "${homemgrModules}/programs/aerospace"
  ];

  programs.home-manager.enable = true;

  # Ensure homebrew is in PATH
  home.sessionPath = [
    "/opt/homebrew/bin/"
  ];

  # reload systemd units when changing confs
  systemd.user.startServices = "sd-switch"

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.11";
}