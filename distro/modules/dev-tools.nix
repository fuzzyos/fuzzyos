# FuzzyOS — Developer tools
# Pre-installed toolchains and language servers for common stacks.
{ config, pkgs, lib, unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    # ── Version managers ───────────────────────────────────────────────
    # Node.js (via unstable for latest)
    unstable.nodejs_22
    unstable.corepack_22

    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv
    uv

    # Rust
    rustup

    # Go
    go

    # ── Build tools ────────────────────────────────────────────────────
    gcc
    gnumake
    cmake
    pkg-config
    openssl

    # ── Containers ─────────────────────────────────────────────────────
    docker-compose
    lazydocker

    # ── Git tools ──────────────────────────────────────────────────────
    gh                  # GitHub CLI
    lazygit
    delta               # Git diff viewer

    # ── Database tools ─────────────────────────────────────────────────
    sqlite
    postgresql

    # ── Language servers (for editors) ─────────────────────────────────
    nodePackages.typescript-language-server
    nil                 # Nix LSP
    rust-analyzer
    pyright
    gopls

    # ── Misc dev tools ─────────────────────────────────────────────────
    httpie
    websocat
    watchexec
  ];

  # ── Docker ───────────────────────────────────────────────────────────
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # Start on demand
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # ── direnv integration ───────────────────────────────────────────────
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
