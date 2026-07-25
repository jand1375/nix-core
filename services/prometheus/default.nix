{
  config,
  pkgs,
  lib,
  ...
}:
let
  nodeExporterFull = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/1860/revisions/latest/download";
    hash = "sha256-GExrdAnzBtp1Ul13cvcZRbEM6iOtFrXXjEaY6g6lGYY=";
  };
  ciscoDashboard = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/21962/revisions/1/download";
    hash = "sha256-NmzLIYoqoz24zLQB+k6yBj5Iux5+werIAkCxgbv3t20=";
  };
  officialSnmpConfig = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/prometheus/snmp_exporter/v0.30.1/snmp.yml";
    hash = pkgs.lib.fakeHash;
  };
in
{
  environment.etc."grafana-dashboards/node-exporter-full.json".source = nodeExporterFull;
  environment.etc."grafana-dashboards/cisco-3850.json".source = ciscoDashboard;

  services.prometheus = {
    enable = true;
    port = 9090;
    globalConfig = {
      scrape_interval = "15s";
      evaluation_interval = "15s";
    };

    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [ { targets = [ "127.0.0.1:9090" ]; } ];
      }

      {
        job_name = "node-exporter";
        static_configs = [
          {
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }

      {
        job_name = "cisco-3850";
        metrics_path = "/snmp";
        params = {
          module = [ "if_mib" ];
          auth = [ "cisco_v3" ];
        };
        static_configs = [ { targets = [ "10.90.0.1" ]; } ];
        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "127.0.0.1:${toString config.services.prometheus.exporters.snmp.port}";
          }
        ];
      }
    ];
    # Enable Node Eplorer
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "systemd"
          "cpu"
          "meminfo"
          "diskstats"
          "netdev"
        ];
        port = 9100;
      };
      snmp = {
        enable = true;
        port = 9116;
        environmentFile = "/root/snmp-exporter.env";
        configuration = {
          auths = {
            cisco_v3 = {
              version = 3;
              security_level = "authPriv";
              username = "nyx";
              auth_protocol = "SHA";
              password = "\$SNMP_AUTH_PASSWORD";
              priv_protocol = "AES";
              priv_password = "\$SNMP_PRIV_PASSWORD";
            };
          };
       };
        extraFlags = [ "--config.file=${officialSnmpConfig}"
        };
      };
    };
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
      };
      security = {
        secret_key = "nixos-grafana-test";
      };
      dashboards = {
        min_refresh_interval = "5s";
      };
    };
    # Add Prometheus as a Data Source
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:9090";
          isDefault = true;
        }
      ];
      dashboards.settings = {
        apiVersion = 1;
        providers = [
          {
            name = "Node Exporter";
            orgId = 1;
            folder = "Infrastructure";
            type = "file";
            disableDeletion = true;
            editable = false;
            options = {
              path = "/etc/grafana-dashboards";
            };
          }
        ];
      };
    };
  };
}
