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

  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.libiconv
    pkgs.fd
    pkgs.just
    pkgs.git-filter-repo
    pkgs.mycli
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.exiftool
    pkgs.imagemagick
    (pkgs.nerdfonts.override {
      fonts = [ "Hack" ];
    })
    pkgs.lua
    pkgs.luajitPackages.luarocks
    pkgs.kubectl
    pkgs.wget
    pkgs.mercurial
    pkgs.ruby
    pkgs.curl
    pkgs.httpie
    pkgs.go
    pkgs.jq
    pkgs.redis
    pkgs.coreutils
    pkgs.clipboard-jh
  ];

  xdg.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = "source ~/.config/home-manager/config.fish";
  };

  programs.git = {
    enable = true;
    includes = [{ path = "~/.config/home-manager/.gitconfig"; }];
    delta = {
      enable = true;
    };
  };

  programs.fzf = {
    enable = true;
    package = pinned.fzf;
    defaultCommand = "fd --type f -H";
    defaultOptions = [ "--bind=ctrl-j:accept" ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    extraConfig = "source ~/.config/home-manager/tmux.conf";
  };

  programs.gh = {
    enable = true;
  };

  programs.ripgrep = {
    enable = true;
    arguments = [ "--hidden" ];
  };

  programs.bat = {
    enable = true;
  };

  programs.lazygit = {
    enable = true;
  };

  xdg.configFile."lazygit/config.yml".source = ./lazygit.yml;

  programs.k9s = {
    enable = true;
  };

  programs.lsd = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
  };
}
