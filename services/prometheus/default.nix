{ config, pkgs, ...}:
{
   services.prometheus = 
     {
        enable = true;
        port = 9090;
           scrapeConfigs = [
               {
                 job_name = "prometheus";
                 static_configs = [{ targets = [ "127.0.0.1:9090" ]; }];
                }

               { 
                 job_name = "node-exporter";
                 static_configs = [{ targets = 
                                     [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ]; }];
                } 
                            ];
                                     # Enable Node Eplorer
       exporters = {
               node = {
                      enable = true;
                      enabledCollectors = [ "systemd" "cpu" "meminfo" "diskstats" "netdev" ];
                      port = 9100;
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
                security = { secret_key = "nixos-grafana-test"; };
              dashboards = { min_refresh_interval = "5s"; };
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
                          };
                     };

}
