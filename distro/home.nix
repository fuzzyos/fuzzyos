# FuzzyOS — Home Manager configuration for the default user
{ config, pkgs, lib, ... }:

{
  home.stateVersion = "24.11";

  # ── Shell ────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
    };
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -la --icons";
      lt = "eza --tree --icons";
      cat = "bat";
      g = "git";
      f = "fuzzy";           # Quick access to fuzzy-code
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    initExtra = ''
      # Fuzzy shell integration — Alt+F to launch fuzzy in current dir
      fuzzy-inline() {
        if command -v fuzzy &>/dev/null; then
          fuzzy
        fi
      }
      zle -N fuzzy-inline
      bindkey '\ef' fuzzy-inline
    '';
  };

  # ── Starship prompt ──────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$nodejs"
        "$python"
        "$rust"
        "$character"
      ];
      character = {
        success_symbol = "[❯](bold purple)";
        error_symbol = "[❯](bold red)";
      };
      directory = {
        style = "bold blue";
        truncation_length = 3;
      };
      git_branch = {
        style = "bold purple";
        symbol = " ";
      };
      nix_shell = {
        symbol = " ";
        style = "bold cyan";
      };
    };
  };

  # ── Git ──────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rerere.enabled = true;
      column.ui = "auto";
      branch.sort = "-committerdate";
    };
  };

  # ── Terminal (kitty) ─────────────────────────────────────────────────
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 13;
      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      background_opacity = "0.95";
      # Purple-tinted dark theme to match FuzzyOS branding
      foreground = "#e0def4";
      background = "#191724";
      cursor = "#ba55d3";
      selection_foreground = "#e0def4";
      selection_background = "#403d52";
      # Tabs
      active_tab_foreground = "#191724";
      active_tab_background = "#ba55d3";
      inactive_tab_foreground = "#e0def4";
      inactive_tab_background = "#26233a";
    };
  };

  # ── Hyprland user config ─────────────────────────────────────────────
  xdg.configFile."hypr/hyprland.conf".text = ''
    # ── Monitors ─────────────────────────────────────────────
    monitor=,preferred,auto,1

    # ── Input ────────────────────────────────────────────────
    input {
      kb_layout = us
      follow_mouse = 1
      touchpad {
        natural_scroll = true
      }
    }

    # ── Appearance ───────────────────────────────────────────
    general {
      gaps_in = 4
      gaps_out = 8
      border_size = 2
      col.active_border = rgba(ba55d3ff) rgba(9932ccff) 45deg
      col.inactive_border = rgba(595959aa)
      layout = dwindle
    }

    decoration {
      rounding = 8
      blur {
        enabled = true
        size = 5
        passes = 2
      }
      shadow {
        enabled = true
        range = 8
        render_power = 2
        color = rgba(1a1a1aee)
      }
    }

    animations {
      enabled = true
      bezier = ease, 0.25, 0.1, 0.25, 1
      animation = windows, 1, 4, ease
      animation = fade, 1, 3, ease
      animation = workspaces, 1, 4, ease
    }

    # ── Keybindings ──────────────────────────────────────────
    $mod = SUPER

    bind = $mod, Return, exec, kitty
    bind = $mod, Q, killactive
    bind = $mod, M, exit
    bind = $mod, Space, exec, wofi --show drun
    bind = $mod, E, exec, nautilus
    bind = $mod, F, fullscreen
    bind = $mod, V, togglefloating

    # Fuzzy — launch AI assistant in terminal
    bind = $mod, A, exec, kitty --title "Fuzzy Code" fuzzy

    # Move focus
    bind = $mod, H, movefocus, l
    bind = $mod, L, movefocus, r
    bind = $mod, K, movefocus, u
    bind = $mod, J, movefocus, d

    # Workspaces
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod SHIFT, 1, movetoworkspace, 1
    bind = $mod SHIFT, 2, movetoworkspace, 2
    bind = $mod SHIFT, 3, movetoworkspace, 3
    bind = $mod SHIFT, 4, movetoworkspace, 4
    bind = $mod SHIFT, 5, movetoworkspace, 5

    # Resize
    bind = $mod CTRL, H, resizeactive, -40 0
    bind = $mod CTRL, L, resizeactive, 40 0
    bind = $mod CTRL, K, resizeactive, 0 -40
    bind = $mod CTRL, J, resizeactive, 0 40

    # Screenshot
    bind = , Print, exec, grim -g "$(slurp)" - | wl-copy

    # ── Autostart ────────────────────────────────────────────
    exec-once = waybar
    exec-once = dunst
    exec-once = swww-daemon && swww img ~/.config/hypr/wallpaper.png
  '';

  # ── Waybar ───────────────────────────────────────────────────────────
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "pulseaudio" "battery" "tray" ];
        clock = {
          format = "{:%H:%M  %a %b %d}";
        };
        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };
        network = {
          format-wifi = " {essid}";
          format-disconnected = "󰤮 ";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-icons.default = [ "" "" "" ];
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
      }
      window#waybar {
        background: rgba(25, 23, 36, 0.9);
        color: #e0def4;
        border-bottom: 2px solid #ba55d3;
      }
      #workspaces button {
        padding: 0 8px;
        color: #6e6a86;
      }
      #workspaces button.active {
        color: #ba55d3;
        border-bottom: 2px solid #ba55d3;
      }
      #clock, #battery, #network, #pulseaudio {
        padding: 0 10px;
      }
    '';
  };

  # ── Wofi (app launcher) ─────────────────────────────────────────────
  xdg.configFile."wofi/style.css".text = ''
    window {
      background: rgba(25, 23, 36, 0.95);
      border: 2px solid #ba55d3;
      border-radius: 12px;
    }
    #input {
      background: #26233a;
      color: #e0def4;
      border: none;
      border-radius: 8px;
      padding: 8px 12px;
      margin: 8px;
    }
    #entry:selected {
      background: #ba55d3;
      border-radius: 6px;
    }
  '';

  # ── Wallpaper ────────────────────────────────────────────────────────
  xdg.configFile."hypr/wallpaper.png".source = ./branding/wallpaper.png;

  # ── Fuzzy config directory ───────────────────────────────────────────
  xdg.configFile."fuzzy/config.json".text = builtins.toJSON {
    theme = "dark";
    defaultProvider = "anthropic";
    telemetry = false;
  };
}
