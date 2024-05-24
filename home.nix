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
    vesktop
    kate
    kitty
    postgresql
    wine
    vscode
    jetbrains.datagrip
    pgadmin4-desktopmode
    brave
    obsidian
    alacritty
    neovim
    thunderbird
    warp-terminal
    github-desktop
    jetbrains.idea-ultimate
    unityhub
    jetbrains.rider
    davinci-resolve-studio
    kcalc
    krita
    filezilla
    steam
    jdk22
    heroic
    lutris
    armcord
    bottles
    element
    obs-studio
    mpv
    tree
    git
    ripgrep
    wget
    eza
    bat
    zoxide
    freshfetch
    neofetch
    nushell
    starship
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

  # Define and enable programs
  programs = {
    nushell = {
      enable = true;
      configFile.source = ./config.nu;
      extraConfig = ''
        let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
        }
      $env.config = {
        show_banner: false,
        completions: {
          case_sensitive: false,
          quick: true,
          partial: true,
          algorithm: "fuzzy",
          external: {
            enable: true,
            max_results: 100,
            completer: $carapace_completer
          }
        }
      }
      $env.PATH = ($env.PATH | split row (char esep) | prepend /home/toby/.apps | append /usr/bin/env)
      '';
      shellAliases = {
        vi = "nvim";
        vim = "nvim";
        cd = "z";
      };
    };
    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };

  # Enable Home Manager
  programs.home-manager.enable = true;
}

