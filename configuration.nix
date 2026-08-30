# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Include the results of the hardware scan.
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    # Define hostname.
    hostName = "nixos";

    # Configure network connections interactively.
    networkmanager.enable = true;
  };

  # Enable and configure bluetooth.
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_ZA.UTF-8";

  # Configure keymap in X11.
  services.xserver.xkb.layout = "us";

  # Define a user account.
  users.users."davinmoosa" = {
    isNormalUser = true;
    description = "Davin Moosa";
    extraGroups = [ "dialout" "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and nix commands.
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # wget
    arduino-ide
    anki
    bat
    eza
    fd
    freecad
    fzf
    gcc
    git
    git-crypt
    godot
    gdscript-formatter
    krita
    libreoffice
    proton-vpn
    pyrefly
    ripgrep
    ruff
    rumdl
    tealdeer
    tree-sitter
    uv
    zoxide
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa
  ];

  # List font packages installed in system profile.
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];

  # List programs that you want to enable:
  programs = {
    fish.enable = true;
    neovim.enable = true;
    nix-ld.enable = true;
    steam.enable = true;
  };

  security.pki.certificateFiles = [
    ./secrets/cert.pem
  ];

  # List services that you want to enable:
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable Plasma
    desktopManager.plasma6.enable = true;

    # Default display manager for Plasma
    displayManager.plasma-login-manager.enable = true;

    flatpak.enable = true;

    # Printing
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

    # Power Management
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      pd.enable = true;
      settings = {
        # TLP
        START_CHARGE_THRESH_BAT0 = 75;
        STOP_CHARGE_THRESH_BAT0 = 1;

        # TLP-RDW
        DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi wwan";
        DEVICES_TO_DISABLE_ON_WIFI_CONNECT = "wwan";
        DEVICES_TO_DISABLE_ON_WWAN_CONNECT = "wifi";

        DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi wwan";
        DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT = "";
        DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT = "";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
