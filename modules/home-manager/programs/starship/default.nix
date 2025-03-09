{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      directory = {
        style = "bold lavender";
      };
      aws = {
        disabled = false;
        };
    };
  };
  # Enable catppuccin theming for starship.
  # catppuccin.starship.enable = true;
}
