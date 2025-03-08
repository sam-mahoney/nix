{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;

    # TODO kickstart
    #extraPackages = with pkgs; [
    #  alejandra
    #  black
    #  golangci-lint
    #  gopls
    #  gotools
    #  hadolint
    #  isort
    #  lua-language-server
    #  markdownlint-cli
    #  nixd
    #  nodePackages.bash-language-server
    #  nodePackages.prettier
    #  pyright
    #  ruff
    #  shellcheck
    #  shfmt
    #  stylua
    #  vscode-langservers-extracted
    #  yaml-language-server
    # ];
  };
 
  # source lua config from this repo
  #xdg.configFile = {
  #  "nvim" = {
  #    source = ./lazyvim;
  #    recursive = true;
  #  };
  #};
}
