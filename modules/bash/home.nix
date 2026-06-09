{ config, pkgs, ... }:
{
  programs.bash.enable = true;
  programs.bash.enableCompletion = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
