{ lib, config, pkgs, ... }:

{

  users.users.nixbot = {
    description = "User for nixbot";
    home = "/var/lib/nixbot";
    createHome = true;
    group = "users";
  };

  environment.systemPackages = [ pkgs.nix-index ];

  systemd.services.nixbot = {
    description = "Nix bot";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
      export PATH="${lib.makeBinPath (with pkgs; [ gnutar gzip ])}:$PATH"
      ${import ./default.nix { inherit pkgs; }}/bin/nixbot ${./release.nix}
    '';
    serviceConfig = {
      User = "nixbot";
      Restart = "always";
      RestartSec = 1;
      MemoryMax = "100M";
      CPUQuota = "50%";
    };
  };
}
