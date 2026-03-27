_: {
  services.prometheus.exporters.node = {
    enable = false;
    port = 9100;
    enabledCollectors = [ "cpu" "meminfo" "diskstats" "filesystem" "loadavg" ];
  };
}
