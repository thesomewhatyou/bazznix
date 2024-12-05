let
  hosts = [
    "fallarbor"
    "lavaridge"
    "mauville"
    "pacifidlog"
    "petalburg"
    "rustboro"
    "slateport"
  ];
  users = [
    "aly_fallarbor"
    "aly_lavaridge"
    "aly_mauville"
    "aly_pacifidlog"
    "aly_petalburg"
    "aly_rustboro"
    "aly_slateport"
  ];
  systemKeys = builtins.map (host: builtins.readFile ./publicKeys/root_${host}.pub) hosts;
  userKeys = builtins.map (user: builtins.readFile ./publicKeys/${user}.pub) users;
  keys = systemKeys ++ userKeys;
in {
  "aly/syncthing/pacifidlog/cert.age".publicKeys = keys;
  "aly/syncthing/pacifidlog/key.age".publicKeys = keys;
  "aly/transmissionRemote.age".publicKeys = keys;
  "tailscale/authKeyFile.age".publicKeys = keys;
  "transmission.age".publicKeys = keys;
  "wifi.age".publicKeys = keys;
}
