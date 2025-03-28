{...}: {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    clock24 = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    newSession = true;
    terminal = "screen-256color";
    # TODO: https://github.com/ThePrimeagen/.dotfiles/blob/master/tmux/.tmux.conf
    extraConfig = ''
    	set -ga terminal-overrides ",screen-256color*:Tc"
	set-option -g default-terminal "screen-256color"
    '';
  };
}
