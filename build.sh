#!/usr/bin/env bash
set -xe

nix build .#darwinConfigurations.pavel-mbp18.system --extra-experimental-features 'nix-command flakes'

./result/sw/bin/darwin-rebuild switch --flake .

git commit -am "wip: $(date)"
