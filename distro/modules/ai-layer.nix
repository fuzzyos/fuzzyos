# FuzzyOS — AI layer: fuzzy-code, fuzzy-tui, and agent services
{ config, pkgs, lib, unstable, ... }:

let
  nodejs = unstable.nodejs_22;

  fuzzy-wrapper = pkgs.writeShellScriptBin "fuzzy" ''
    exec ${nodejs}/bin/npx -y @fuzzyos/fuzzy-code@0.3.15 "$@"
  '';
in
{
  # ── Fuzzy CLI ────────────────────────────────────────────────────────
  environment.systemPackages = [
    nodejs
    fuzzy-wrapper
  ];

  # ── Environment variables ────────────────────────────────────────────
  environment.variables = {
    # Default provider (user overrides in ~/.config/fuzzy/config.json)
    FUZZY_DEFAULT_PROVIDER = "anthropic";
  };

  # ── Fuzzy agent daemon (optional background agent) ───────────────────
  # systemd.user.services.fuzzy-agent = {
  #   description = "FuzzyOS Background Agent";
  #   wantedBy = [ "default.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${fuzzy-code}/bin/fuzzy agent --daemon";
  #     Restart = "on-failure";
  #     RestartSec = 5;
  #   };
  #   environment = {
  #     HOME = "%h";
  #     XDG_CONFIG_HOME = "%h/.config";
  #   };
  # };

  # ── MCP servers (pre-configured) ────────────────────────────────────
  # These provide system-level tool access to the AI agent
  environment.etc."fuzzy/mcp-servers.json".text = builtins.toJSON {
    servers = {
      filesystem = {
        command = "npx";
        args = [ "-y" "@anthropic-ai/mcp-filesystem" "/home" ];
        description = "File system access for the AI agent";
      };
      shell = {
        command = "npx";
        args = [ "-y" "@anthropic-ai/mcp-shell" ];
        description = "Shell command execution for the AI agent";
      };
    };
  };
}
