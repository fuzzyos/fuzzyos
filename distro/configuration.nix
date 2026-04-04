# FuzzyOS — Base system configuration
{ config, pkgs, lib, unstable, modulesPath, ... }:

{
  # ── System ───────────────────────────────────────────────────────────
  system.stateVersion = "24.11";
  networking.hostName = "fuzzyos";
  time.timeZone = "UTC";

  # ── Boot ─────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ISO support (builds a live ISO — minimal, no Calamares/X11)
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  isoImage = {
    isoName = lib.mkForce "fuzzyos-${config.system.nixos.release}.iso";
    volumeID = lib.mkForce "FUZZYOS";
    makeEfiBootable = true;
    makeUsbBootable = true;
  };

  # ── Networking ───────────────────────────────────────────────────────
  networking.networkmanager.enable = true;
  networking.wireless.enable = lib.mkForce false; # conflicts with networkmanager
  networking.firewall.enable = true;

  # ── Locale ───────────────────────────────────────────────────────────
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # ── Audio ────────────────────────────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # ── Users ────────────────────────────────────────────────────────────
  users.users.fuzzy = {
    isNormalUser = true;
    description = "FuzzyOS User";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # ── Core packages ────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # System essentials
    coreutils
    curl
    wget
    git
    htop
    btop
    file
    unzip
    ripgrep
    fd
    jq
    tree

    # Shell
    zsh
    starship
    fzf
    zoxide
    bat
    eza
    direnv

    # Editors
    neovim
    helix

    # Terminal
    kitty
    tmux

    # Browser
    firefox
  ];

  # ── Services ─────────────────────────────────────────────────────────
  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  # ── Nix settings ─────────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  programs.zsh.enable = true;
}
