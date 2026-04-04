# FuzzyOS — AI layer: fuzzy-code, fuzzy-tui, and agent services
{ config, pkgs, lib, unstable, ... }:

let
  # Node.js runtime for fuzzy-code CLI
  nodejs = unstable.nodejs_22;

  # fuzzy-code installed globally via npm
  fuzzy-code = pkgs.stdenv.mkDerivation {
    pname = "fuzzy-code";
    version = "0.3.15";
    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/@fuzzyos/fuzzy-code/-/fuzzy-code-0.3.15.tgz";
      # TODO: update hash after first build
      hash = lib.fakeHash;
    };
    nativeBuildInputs = [ nodejs pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out/lib/node_modules/@fuzzyos/fuzzy-code
      cp -r . $out/lib/node_modules/@fuzzyos/fuzzy-code
      mkdir -p $out/bin
      makeWrapper ${nodejs}/bin/node $out/bin/fuzzy \
        --add-flags "$out/lib/node_modules/@fuzzyos/fuzzy-code/dist/cli.js"
    '';
  };
in
{
  # ── Fuzzy CLI ────────────────────────────────────────────────────────
  environment.systemPackages = [
    nodejs
    # fuzzy-code  # uncomment once hash is set
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
