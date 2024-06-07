{ config, pkgs, ... }:

{
  # Define the Home Manager version to ensure compatibility
  home.stateVersion = "23.11"; # Adjust to your Home Manager version
  
  # User-specific configuration
  home.username = "toby";
  home.homeDirectory = "/home/toby";
  
  # Allow unfree packages if needed
  nixpkgs.config.allowUnfree = true;

  # Define packages to be installed
  home.packages = with pkgs; [
    spotify
    jdk22
    kate
    kitty
    kubernetes
    kubectl
    vscode
    pgadmin4-desktopmode
    obsidian
    neovim
    thunderbird
    warp-terminal
    github-desktop
    unityhub
    davinci-resolve-studio
    kcalc
    krita
    filezilla
    heroic
    lutris
    armcord
    bottles
    element
    obs-studio
    mpv
    starship
    tree
    git
    ripgrep
    wget
    eza
    bat
    zoxide
    freshfetch
    neofetch
    carapace
    gcc
    xsel
    lunar-client
    maven
    nodejs
    cargo
    dotnetCorePackages.sdk_6_0_1xx
    ffmpeg
    lazygit
    cmatrix
    handbrake
    telegram-desktop
    gimp
    waydroid
  ];

  # Define dotfiles to be managed
  home.file = {
    # Example: ".screenrc".source = "${config.home.homeDirectory}/.screenrc";
  };

  # Define environment variables
  home.sessionVariables = {
    # Example: EDITOR = "emacs";
  };

  # Enable Home Manager
  programs.home-manager.enable = true;
}

