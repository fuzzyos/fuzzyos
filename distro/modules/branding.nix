# FuzzyOS — Branding and theming
{ config, pkgs, lib, ... }:

{
  # ── Boot splash ──────────────────────────────────────────────────────
  boot.plymouth = {
    enable = true;
    # TODO: create custom FuzzyOS plymouth theme
    # theme = "fuzzyos";
    # themePackages = [ fuzzyos-plymouth-theme ];
  };

  # ── GRUB branding ───────────────────────────────────────────────────
  # boot.loader.grub = {
  #   # Only used if systemd-boot is disabled
  #   splashImage = ../branding/grub-splash.png;
  # };

  # ── OS release info ──────────────────────────────────────────────────
  environment.etc."os-release".text = lib.mkForce ''
    NAME="FuzzyOS"
    ID=fuzzyos
    ID_LIKE=nixos
    VERSION="0.1.0"
    VERSION_ID="0.1.0"
    PRETTY_NAME="FuzzyOS 0.1.0"
    HOME_URL="https://fuzzyos.com"
    DOCUMENTATION_URL="https://fuzzyos.com/docs"
    BUG_REPORT_URL="https://github.com/fuzzyos/fuzzyos/issues"
    LOGO="fuzzyos"
  '';

  # ── GTK / cursor theme ──────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    adwaita-icon-theme
  ];

  # ── Issue banner (shown on TTY login) ────────────────────────────────
  environment.etc.issue.text = ''

    \e[35m┌─────────────────────────────────────┐
    │                                     │
    │    ╔═╗╦ ╦╔═╗╔═╗╦ ╦  ╔═╗╔═╗        │
    │    ╠╣ ║ ║╔═╝╔═╝╚╦╝  ║ ║╚═╗        │
    │    ╚  ╚═╝╚═╝╚═╝ ╩   ╚═╝╚═╝        │
    │                                     │
    │    AI-first operating system         │
    └─────────────────────────────────────┘\e[0m

    \n (\l)

  '';

  # ── MOTD ─────────────────────────────────────────────────────────────
  users.motd = ''
    Welcome to FuzzyOS — type 'fuzzy' to start the AI assistant.
  '';
}
