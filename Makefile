.PHONY: all

all: update install missing-files apply

update:
	git pull

apply:
	home-manager switch

expire:
	home-manager expire-generations "-1 days"

# Install home-manager using Nix
install: install-nix enable-nix-flakes
ifeq (, $(shell which home-manager))
	nix run home-manager/master -- switch -b backup
endif

# Install Nix and add channel if missing
install-nix:
ifeq (, $(shell which nix))
	sh <(curl -L https://nixos.org/nix/install) --daemon
	nix-channel --add https://nixos.org/channels/nixpkgs-unstable
	nix-channel --update
endif

# Patches Nix configuration to enable flakes support
enable-nix-flakes:
ifneq (,$(findstring extra-experimental-features,$(cat /etc/nix/nix.conf)))
	echo "extra-experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
	echo "max-jobs = auto" | sudo tee -a /etc/nix/nix.conf
	sudo systemctl restart nix-daemon.service
endif

missing-files: missing-sshnix

# ssh.nix is missing from repository for security reasons.
# This creates en empty file so home-manager does not fail.
missing-sshnix:
ifeq (,$(wildcard ./programs/ssh.nix))
	echo "{}" > ./programs/ssh.nix
endif
