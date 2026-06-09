{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    withRuby = true;
    withPython3 = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nil
      nixfmt
      rust-analyzer
      pyright
    ];
  };

  xdg.configFile."nvim/init.lua".source = ./init.lua;
}
