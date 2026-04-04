# FuzzyOS — Desktop environment
# Uses Hyprland (Wayland compositor) for a modern, tiling experience.
# Alternatively switch to GNOME or sway by changing this module.
{ config, pkgs, lib, ... }:

{
  # ── Display server ───────────────────────────────────────────────────
  services.xserver.enable = false; # Wayland-only

  # ── Hyprland ─────────────────────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ── Login manager ────────────────────────────────────────────────────
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # ── Desktop packages ─────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Wayland essentials
    waybar            # Status bar
    wofi              # App launcher
    dunst             # Notifications
    swaylock          # Screen lock
    swayidle          # Idle management
    grim              # Screenshot
    slurp             # Region selection
    wl-clipboard      # Clipboard
    swww              # Wallpaper

    # File manager
    nautilus

    # Theme
    adwaita-icon-theme
    papirus-icon-theme
    gnome-themes-extra

    # Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];

  # ── Fonts ────────────────────────────────────────────────────────────
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };
  };

  # ── Portal (screen sharing, file dialogs) ────────────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
