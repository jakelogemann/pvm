inputs @ {
  config,
  lib,
  pkgs,
  modulesPath,
  hostName,
  ...
}: let
  inherit (pkgs.lib) mkForce;
  dnsServers = lib.concatStringsSep "," [
    "10.124.57.141"
    "10.124.57.160"
  ];
in {
  networking = {
    enableIPv6 = true;
    firewall.allowPing = true;
    firewall.allowedTCPPorts = [];
    firewall.allowedUDPPorts = [];
    firewall.autoLoadConntrackHelpers = true;
    firewall.checkReversePath = true;
    firewall.enable = true;
    firewall.logRefusedConnections = true;
    firewall.logRefusedPackets = true;
    firewall.logReversePathDrops = true;
    firewall.pingLimit = "--limit 1/minute --limit-burst 5";
    firewall.rejectPackets = true;
    nameservers = mkForce ["127.0.0.1" "::1"];
    resolvconf.enable = mkForce false;
    dhcpcd.extraConfig = mkForce "nohook resolv.conf";
    networkmanager.dns = mkForce "none";
    useDHCP = true;
    useHostResolvConf = true;
  };

  services.dnscrypt-proxy2 = {
    enable = mkForce true;
    settings = {
      # Immediately respond to A and AAAA queries for host names without a
      # domain name.
      block_unqualified = true;
      # Immediately respond to queries for local zones instead
      # of leaking them to upstream resolvers (always causing errors or
      # timeouts).
      block_undelegated = true;
      # ------------------------
      server_names = ["cloudflare" "cloudflare-ipv6" "cloudflare-security" "cloudflare-security-ipv6"];
      ipv6_servers = true;
      ipv4_servers = true;
      use_syslog = true;
      require_nolog = true;
      require_nofilter = false;
      edns_client_subnet = ["0.0.0.0/0" "2001:db8::/32"];
      require_dnssec = true;
      blocked_query_response = "refused";
      block_ipv6 = false;

      allowed_ips.allowed_ips_file =
        /*
         Allowed IP lists support the same patterns as IP blocklists
         If an IP response matches an allow ip entry, the corresponding session
         will bypass IP filters.
         
         Time-based rules are also supported to make some websites only accessible at specific times of the day.
         */
        pkgs.writeText "allowed_ips" ''
        '';

      cloaking_rules =
        /*
         Cloaking returns a predefined address for a specific name.
         In addition to acting as a HOSTS file, it can also return the IP address
         of a different name. It will also do CNAME flattening.
         */
        pkgs.writeText "cloaking_rules" ''
          # The following rules force "safe" (without adult content) search
          # results from Google, Bing and YouTube.
          www.google.*             forcesafesearch.google.com
          www.bing.com             strict.bing.com
          =duckduckgo.com          safe.duckduckgo.com
          www.youtube.com          restrictmoderate.youtube.com
          m.youtube.com            restrictmoderate.youtube.com
          youtubei.googleapis.com  restrictmoderate.youtube.com
          youtube.googleapis.com   restrictmoderate.youtube.com
          www.youtube-nocookie.com restrictmoderate.youtube.com
        '';

      forwarding_rules = pkgs.writeText "forwarding_rules" ''
        internal.digitalocean.com ${dnsServers}
        *.internal.digitalocean.com ${dnsServers}
        10.in.arpa ${dnsServers}
      '';
      cloak_ttl = 600;
      allowed_names.allowed_names_file = pkgs.writeText "allowed_names" "";
      blocked_names.blocked_names_file = pkgs.writeText "blocked_names" "";
      blocked_ips.blocked_ips_file = pkgs.writeText "blocked_ips" "";
      query_log.file = "/dev/stdout";
      query_log.ignored_qtypes = ["DNSKEY"];
      blocked_names.log_file = "/dev/stdout";
      allowed_ips.log_file = "/dev/stdout";
      blocked_ips.log_file = "/dev/stdout";
      allowed_names.log_file = "/dev/stdout";
      sources = {
        public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 72;
          prefix = "";
        };
        relays = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md"
            "https://download.dnscrypt.info/resolvers-list/v3/relays.md"
            "https://ipv6.download.dnscrypt.info/resolvers-list/v3/relays.md"
            "https://download.dnscrypt.net/resolvers-list/v3/relays.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/relays.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 72;
          prefix = "";
        };
        odoh-servers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-servers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/odoh-servers.md"
            "https://ipv6.download.dnscrypt.info/resolvers-list/v3/odoh-servers.md"
            "https://download.dnscrypt.net/resolvers-list/v3/odoh-servers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/odoh-servers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 24;
          prefix = "";
        };
        odoh-relays = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/odoh-relays.md"
            "https://download.dnscrypt.info/resolvers-list/v3/odoh-relays.md"
            "https://ipv6.download.dnscrypt.info/resolvers-list/v3/odoh-relays.md"
            "https://download.dnscrypt.net/resolvers-list/v3/odoh-relays.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/odoh-relays.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 24;
          prefix = "";
        };
      };
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig.StateDirectory = mkForce "dnscrypt-proxy2";
}
