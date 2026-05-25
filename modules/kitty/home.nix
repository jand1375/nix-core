{ pkgs, ...}:
{
  programs.kitty = { 
    enable = true;
         settings = {
                      shell = "fish";
                      font_family = "FiraCode Nerd Font";
                      font_size = "16";
                      background_opacity = "0.95";
                      background = "#282c34";
                      foreground = "#abb2bf";
                      window_padding_width = "6";
                      "map ctrl+shift+c" = "copy_to_clipboard";
                      "map ctrl+shift+v" = "paste_from_clipboard";
                      };
                  };
  }
