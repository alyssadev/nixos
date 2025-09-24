up:
  nix flake update

check:
  nix flake check

boot:
  nixos-rebuild boot --flake . --use-remote-sudo

commit:
  git add .
  git commit -a -m "update"

_switch: commit
  nixos-rebuild switch --flake . --use-remote-sudo

push:
  git push origin --all

switch: _switch push

debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --verbose

# Update specific input
# usage: make upp i=home-manager
upp:
  nix flake update $(i)

history:
  nix profile history --profile /nix/var/nix/profiles/system

repl:
  nix repl -f flake:nixpkgs

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  sudo nix-collect-garbage --delete-old
