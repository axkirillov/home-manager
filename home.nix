{ pkgs, pinned, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "aleksandr.kirillov";
  home.homeDirectory = "/Users/aleksandr.kirillov";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.libiconv
  ];

  programs.git = {
    enable = true;
    includes = [{ path = "~/.config/home-manager/.gitconfig"; }];
  };

  programs.fzf = {
    enable = true;
    package = pinned.fzf;
    defaultCommand = "fd --type f -H";
    defaultOptions = [ "--bind=ctrl-j:accept" ];
  };
}
