#!/usr/bin/env bash
set -xe

nix build .#darwinConfigurations.pavel-mbp18.system --extra-experimental-features 'nix-command flakes'

./result/sw/bin/darwin-rebuild switch --flake .

nix build .#packages.x86_64-linux.vmware --builders 'ssh://pavel-nix x86_64-linux' --store ssh-ng://pavel-nix --eval-store auto
nix copy --from ssh-ng://pavel-nix .#packages.x86_64-linux.vmware

git commit -am "wip: $(date)"
