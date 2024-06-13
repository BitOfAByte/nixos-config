{ config, pkgs, lib, inputs, ... }:


let
  # Reference the stable nixpkgs
  stablePkgs = import inputs.stablenixpkgs {
    system = pkgs.system;
    config = { allowUnfree = true; };  # If you use any unfree packages
  };
in

{
  
programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
};
  # Enable experimental Nix features
  nix.settings.experimental-features = "nix-command flakes";

  # Import necessary configurations
  imports = [
    ./hardware-configuration.nix          # Include hardware configuration
    inputs.home-manager.nixosModules.default # Home Manager module
    # ./nvidia.nix                         # NVIDIA configuration (commented out)
    # ./kde.nix # KDE configuration (commented out)
    #./home.nix
  ];

  # User configuration
  users.users.toby = {
    isNormalUser = true;
    description = "toby";
    extraGroups = [ "networkmanager" "wheel" "disk" ];
    shell = pkgs.zsh;
    packages = with stablePkgs; [
      scenebuilder
      jetbrains-toolbox
      pgadmin4-desktopmode
      docker
      oh-my-zsh
      zsh
      tldr
      dart
      alacritty
      bun
      gparted
      drawio
      teamspeak_server
      teamspeak5_client
      wireshark
      #jetbrains.datagrip
      #brave
      firefox
      javaPackages.openjfx21
      discord
      wine64
    ];
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  programs.zsh.enable = true;
  # Home Manager configuration

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.toby = import ./home.nix;
};

  home-manager.backupFileExtension = "backup";

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname configuration
  networking.hostName = "nixos";

  # Enable NetworkManager for networking
  networking.networkmanager.enable = true;

  # Set timezone
  time.timeZone = "Europe/Copenhagen";

  # Internationalization settings
  i18n.defaultLocale = "en_DK.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # X11 windowing system configuration
  services.xserver = {
    enable = true;
    layout = "dk";
    xkbVariant = "";
  };

  # Display manager configuration
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  # Video driver configuration
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  # X11 keymap configuration
  services.xserver.xkb.variant = "";

  # Enable CUPS for printing
  services.printing.enable = true;

  # Enable sound with PipeWire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Enable GameMode
  programs.gamemode.enable = true;

  # Enable KDE Connect
  programs.kdeconnect.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # OpenGL hardware acceleration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };


  # System packages
  environment.systemPackages = with pkgs; [
    inputs.nix-software-center.packages.${system}.nix-software-center
    nh

    nix-output-monitor
    protonup
    mangohud
    libsForQt5.qtstyleplugin-kvantum
    xorg.xrandr
    gparted
    jellyfin-media-player
  ];
  # NH program configuration
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos/";
  };

  virtualisation.waydroid.enable = true;
  # Session variables
  
  programs.nix-ld.enable = true;
  environment.sessionVariables = {
     STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/toby/.steam/root/compatibilitytools.d";
     JAVA_HOME = "/nix/storek65yq9109hqbjlg7sfhcnadga9avqvpm-openjdk-22+36";
     NIXOS_OZONE_WL = "1";
   };

  # System state version
  system.stateVersion = "unstable"; # Did you read the comment?

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
