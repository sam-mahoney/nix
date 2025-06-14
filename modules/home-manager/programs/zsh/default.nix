{
  lib,
  pkgs,
  ...
}:
  #let zshrc = "${builtins.getEnv "HOME"}/dotfiles/dot-zshrc";
#in
  {
  # shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
    shellAliases = {
      ff = "fastfetch";

      # git
      gaa = "git add --all";
      gcam = "git commit --all --message";
      gcl = "git clone";
      gco = "git checkout";
      ggl = "git pull";
      ggp = "git push";

      gcd="cd $(git rev-parse --show-toplevel)";
      # TODO 
      # repo = "cd $HOME/Documents/repositories";
      temp = "cd $HOME/Downloads/temp";
	
      # fzf directories in 'code' and cd into selected 
      ccd = "cd $(find $HOME/code/ -type d | fzf)";

      v = "nvim";
      vi = "nvim";
      vim = "nvim";

      # TODO, map most useful ls commands (-la, -lat, etc) to eza equiv
      # ls = "eza --icons always"; # default view
      # ll = "eza -bhl --icons --group-directories-first"; # long list
      # la = "eza -abhl --icons --group-directories-first"; # all list
      # lt = "eza --tree --level=2 --icons"; # tree
    };
    initContent = (''
      # open commands in $EDITOR with C-e
      #autoload -z edit-command-line
      #zle -N edit-command-line
      #bindkey "^v" edit-command-line
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4444ff'
      ''
      + builtins.readFile ./functions.sh
      );
  };
}
