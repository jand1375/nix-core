{ ... }:

{
  services.prometheus = {
    enable = true;
    port = 9090;

    scrapeConfigs = [
      {
        job_name = "prometheus";

        static_configs = [
          {
            targets = [ "127.0.0.1:9090" ];
          }
        ];
      }
    ];
  };

  services.grafana = {
    enable = true;

    settings.server = {
      http_addr = "127.0.0.1";
      http_port = 3000;
    };

    provision = {
      enable = true;

      datasources.settings.datasources = [
        {
          name = "Prometheus";
          uid = "prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:9090";
          isDefault = true;
        }
      ];
    };
  };
}