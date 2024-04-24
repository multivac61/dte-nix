{ pkgs, ... }:
{
  imports = [
    ./disk-config.nix
    ./shared.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.postgresql.enable = true;
  services.postgresql.ensureDatabases = [ "dte" ];
  services.postgresql.ensureUsers = [{ name = "dte"; ensureDBOwnership = true; }];
  services.postgresql.package = pkgs.postgresql_14;
  services.postgresql.settings = {
    max_connections = "300";
    shared_buffers = "80MB";
  };
  services.postgresqlBackup.enable = true;
  services.vector.enable = true;
  services.vmagent.enable = true;

  networking.hostName = "nylon";
  users = {
    mutableUsers = false;
    users.dte = {
      isNormalUser = true;
      description = "dte";
      initialHashedPassword = "$y$j9T$VVDQbZfb/pSmWvZ11nOYy1$fmFj4b2x5ejAQ9W/fiGCqL0SuRgDXUZx5e/kvfhv9Z9";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
    };
    users.oli = {
      isNormalUser = true;
      description = "oli";
      initialHashedPassword = "$y$j9T$VVDQbZfb/pSmWvZ11nOYy1$fmFj4b2x5ejAQ9W/fiGCqL0SuRgDXUZx5e/kvfhv9Z9";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
    };
  };

  nix.settings.experimental-features = "nix-command flakes";
  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ1uxevLNJOPIPRMh9G9fFSqLtYjK5R7+nRdtsas2KwX olafur@M3.localdomain"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqWL96+z6Wk2IgF6XRyoZAVUXmCmP8I78dUpA4Qy4bh genki@gdrn"
  ];

  nix.settings = {
    trusted-users = [ "root" "@wheel" "dte" ];
    substituters = [
      "https://genki.cachix.org" # In the future this could be DTE's own cache
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "genki.cachix.org-1:5l+wAa4rDwhcd5Wm43eK4N73qJ6GIKmJQ87Nw/bRGfE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Your list of packages here...
    git
    gh
    neofetch
    cachix
    cmatrix
    # other packages...
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

