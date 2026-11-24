{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [
      "ignoredups"
      "erasedups"
    ];
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
