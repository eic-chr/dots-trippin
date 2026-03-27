_: {
  programs.opencode = {
    enable = true;
    settings = {
      autoupdate = false;
      share = "disabled";
      experimental = {
        openTelemetry = false;
        mcp_timeout = 600000;
      };
    };
  };

}
