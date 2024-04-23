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
  services.postgresql.package = pkgs.postgresql_14;
  services.postgresql.settings = {
    max_connections = "300";
    shared_buffers = "80MB";
  };
  services.postgresqlBackup.enable = true;

  networking.hostName = "joip";
  users = {
    mutableUsers = false;
    users.root.hashedPassword = "$y$j9T$0TYJhZQBzM8XWeQt5zrGT1$d4hxYKpJeWV13q48VpyQp5gPGZZAsru8aX2i1O2cv7D";
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

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Your list of packages here...
    git
    gh
    neofetch
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

