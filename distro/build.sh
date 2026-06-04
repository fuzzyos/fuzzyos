#!/usr/bin/env bash
# FuzzyOS — Build script
# Usage:
#   ./build.sh iso     Build bootable ISO image
#   ./build.sh vm      Build and run in a VM (QEMU)
#   ./build.sh check   Validate the configuration without building

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m'

banner() {
  echo -e "${PURPLE}"
  echo "  ╔═╗╦ ╦╔═╗╔═╗╦ ╦  ╔═╗╔═╗"
  echo "  ╠╣ ║ ║╔═╝╔═╝╚╦╝  ║ ║╚═╗"
  echo "  ╚  ╚═╝╚═╝╚═╝ ╩   ╚═╝╚═╝"
  echo -e "${NC}"
  echo "  AI-first operating system"
  echo ""
}

check_nix() {
  if ! command -v nix &>/dev/null; then
    echo -e "${RED}Error: Nix is not installed.${NC}"
    echo "Install it: curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh"
    exit 1
  fi
}

build_iso() {
  echo -e "${GREEN}Building FuzzyOS ISO...${NC}"
  echo "This will take a while on the first run (downloading all packages)."
  echo ""
  nix build .#iso --show-trace
  echo ""
  echo -e "${GREEN}ISO built successfully!${NC}"
  echo "Output: $(readlink -f result/iso/*.iso)"
}

build_vm() {
  echo -e "${GREEN}Building and launching FuzzyOS VM...${NC}"
  nix build .#vm --show-trace
  echo ""
  echo -e "${GREEN}Launching VM...${NC}"
  result/bin/run-*-vm
}

check_config() {
  echo -e "${GREEN}Checking FuzzyOS configuration...${NC}"
  nix eval .#nixosConfigurations.fuzzyos.config.system.build.toplevel --show-trace
  echo -e "${GREEN}Configuration is valid.${NC}"
}

banner
check_nix

case "${1:-help}" in
  iso)
    build_iso
    ;;
  vm)
    build_vm
    ;;
  check)
    check_config
    ;;
  *)
    echo "Usage: $0 {iso|vm|check}"
    echo ""
    echo "  iso    Build a bootable ISO image"
    echo "  vm     Build and launch in QEMU"
    echo "  check  Validate configuration"
    exit 1
    ;;
esac
