{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      aws = {
        disabled = false;
        };
      command_timeout = 10000;
      character = {
	success_symbol = "[>>>](bold green)";
	error_symbol = "[>>>](bold red)";
	vimcmd_symbol = "[V](bold blue)";
      };
    };
  };
  # Enable catppuccin theming for starship.
  # catppuccin.starship.enable = true;
}
