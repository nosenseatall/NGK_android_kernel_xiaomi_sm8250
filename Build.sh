#!/bin/bash

set -euo pipefail

BUILD_START=$(date +"%s")

# ===== Colors =====
yellow='\033[0;33m'
cyan='\033[0;36m'
red='\033[0;31m'
nocol='\033[0m'

echo -e "${cyan}=== Kernel Build Started (MUNCH ONLY) ===${nocol}"

# ===== Safety check =====
[ -d ".git" ] || { echo -e "${red}Not a git repo${nocol}"; exit 1; }

# ===== Cleanup =====
rm -rf out || true
mkdir -p out

# ===== KernelSU setup =====
echo -e "${cyan}Applying KernelSU...${nocol}"
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -

# ===== Environment =====
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="github"
export KBUILD_BUILD_HOST="actions"

# ===== Ensure script exists =====
if [ ! -f "./compile-munch.sh" ]; then
  echo -e "${red}compile-munch.sh not found!${nocol}"
  exit 1
fi

chmod +x compile-munch.sh

# ===== Build =====
echo -e "${cyan}Building MUNCH kernel...${nocol}"
bash ./compile-munch.sh

# ===== Done =====
BUILD_END=$(date +"%s")
DIFF=$((BUILD_END - BUILD_START))

echo -e "${yellow}====================================${nocol}"
echo -e "${yellow}Munch build completed in $((DIFF / 60)) min $((DIFF % 60)) sec${nocol}"
echo -e "${yellow}====================================${nocol}"