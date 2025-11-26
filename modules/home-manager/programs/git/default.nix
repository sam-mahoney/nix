{userConfig, ...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = userConfig.fullName;
	email = userConfig.email;
      };
    };
    #signing = {
    #  key = userConfig.gitKey;
    #  signByDefault = true;
    #};
    delta = {
      enable = true;
      options = {
        keep-plus-minus-markers = true;
        light = false;
        line-numbers = true;
        navigate = true;
        width = 280;
      };
    };
    extraConfig = {
      pull.rebase = "true";
      format.pretty = "%Cred%h%Creset - %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold green)<%an>%Creset";
    };
  };

  # Enable catppuccin theming for git delta
  # catppuccin.delta.enable = true;
}
