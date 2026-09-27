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
  openstackOverviewUpstream = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/21085/revisions/3/download";
    hash = "sha256-sehY4i04Vz6nWn7w6udqeaGog6RUqZ6wTDwpgNmaH2Y=";
  };
  openstackOverview = pkgs.runCommand "openstack-overview.json" { } ''
    sed 's/''${DS_PROMETHEUS}/Prometheus/g' \
    ${openstackOverviewUpstream} > "$out"
  '';

  ciscoDashboardUpstream = pkgs.fetchurl {
    url = "https://grafana.com/api/dashboards/21962/revisions/1/download";
    hash = "sha256-NmzLIYoqoz24zLQB+k6yBj5Iux5+werIAkCxgbv3t20=";
  };
  ciscoDashboard = pkgs.runCommand "cisco-3850-dashboard.json" { } ''
    sed 's/''${DS_PROMETHEUS}/Prometheus/g' \
    ${ciscoDashboardUpstream} > "$out"
  '';

  officialSnmpConfig = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/prometheus/snmp_exporter/v0.30.1/snmp.yml";
    hash = "sha256-TgPrC4f0TBSJwrvGUVUJMcGunfj0VT4IZAyhoiucItQ=";
  };
  openstackExporter = pkgs.buildGoModule {
    pname = "openstack-exporter";
    version = "1.7.0";

    src = pkgs.fetchFromGitHub {
      owner = "openstack-exporter";
      repo = "openstack-exporter";
      rev = "v1.7.0";
      hash = "sha256-FWkSJqKdwjK6wKOGYRWUyZ0KaqIq78sgthnzLqOwpHk=";
    };
    vendorHash = "sha256-ssjNgBd64Edjpm/c8x6vcR+kYE2FY4o+aWn74WuehZU=";
  };
in
{
  # SYSTEMD FOR OPENSTACK EXPORTER
  systemd.services.openstack-exporter = {
    description = "OpenStack Prometheus Exporter";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${openstackExporter}/bin/openstack-exporter --web.listen-address=127.0.0.1:9180 openstack ";
      Restart = "on-failure";
      RestartSec = "5s";
    };
    environment = {
      OS_CLIENT_CONFIG_FILE = "/root/.config/openstack/clouds.yaml";
    };
  };

  environment.systemPackages = [ openstackExporter ];

  environment.etc."grafana-dashboards/infrastructure/node-exporter-full.json".source =
    nodeExporterFull;
  environment.etc."grafana-dashboards/infrastructure/cisco-3850.json".source = ciscoDashboard;
  environment.etc."grafana-dashboards/openstack/openstack-overview.json".source = openstackOverview;

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
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
              "10.0.0.10:9100"
              "10.0.0.11:9100"
              "10.0.0.12:9100"
            ];
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
      {
        job_name = "openstack";
        scrape_interval = "60s";
        scrape_timeout = "55s";
        static_configs = [
          {
            targets = [ "127.0.0.1:9180" ];
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
        enableConfigCheck = false;
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
        extraFlags = [ "--config.file=${officialSnmpConfig}" ];
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
          uuid = "prometheus";
          url = "http://localhost:9090";
          isDefault = true;
        }
      ];
      dashboards.settings = {
        apiVersion = 1;
        providers = [
          {
            name = "Infrastructure";
            orgId = 1;
            folder = "Infrastructure";
            type = "file";
            disableDeletion = false;
            editable = false;
            options = {
              path = "/etc/grafana-dashboards/infrastructure";
            };
          }
          {
            name = "OpenStack";
            orgid = 1;
            folder = "OpenStack";
            type = "file";
            disableDeletion = false;
            editable = false;
            options = {
              path = "/etc/grafana-dashboards/openstack";
            };
          }
        ];
      };
    };
  };
}
