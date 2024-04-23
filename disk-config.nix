# hybdrix.nix - https://github.com/nix-community/disko/blob/master/example/hybrid.nix
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/nvme-INTEL_SSDPEKNW512G8_PHNH938308PX512A";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
