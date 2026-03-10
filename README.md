# FuzzyOS

> **Looking for the fuzzy code?** See **[fuzzy-code](https://github.com/fuzzyos/fuzzy-code)** for installation and usage.

Tools for building AI agents and managing LLM deployments.

## Packages

| Package | Description |
|---------|-------------|
| **[@fuzzyos/fuzzy-ai](https://github.com/fuzzyos/fuzzy-ai)** | Unified multi-provider LLM API (OpenAI, Anthropic, Google, etc.) |
| **[@fuzzyos/fuzzy-agent](https://github.com/fuzzyos/fuzzy-agent)** | Agent runtime with tool calling and state management |
| **[@fuzzyos/fuzzy-code](https://github.com/fuzzyos/fuzzy-code)** | Interactive code CLI |
| **[@fuzzyos/fuzzy-code-vsce](https://github.com/fuzzyos/fuzzy-code-vsce)** | Visual Studio Extension for interactive code CLI |
| **[@fuzzyos/fuzzy-tui](https://github.com/fuzzyos/fuzzy-tui)** | Terminal UI library with differential rendering |
| **[@fuzzyos/fuzzy-web-ui](https://github.com/fuzzyos/fuzzy-web-ui)** | Web components for AI chat interfaces |
| **[@fuzzyos/fuzzy-pods](https://github.com/fuzzyos/fuzzy-pods)** | CLI for managing vLLM deployments on GPU pods |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines and [AGENTS.md](AGENTS.md) for project-specific rules (for both humans and agents).

## Development

```bash
npm install          # Install all dependencies
npm run build        # Build all packages
npm run check        # Lint, format, and type check
./test.sh            # Run tests (skips LLM-dependent tests without API keys)
./fuzzy-test.sh         # Run fuzzy from sources (must be run from repo root)
```

> **Note:** `npm run check` requires `npm run build` to be run first. The web-ui package uses `tsc` which needs compiled `.d.ts` files from dependencies.

## License

MIT
