{ ... }: {
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [ "cpu" "meminfo" "diskstats" "filesystem" "loadavg" ];
  };
}
