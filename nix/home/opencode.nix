{  unstable,...} : {
  programs.opencode = {
    enable = true;
    package = unstable.opencode;
    settings = {
      agent= {
        review= {
          "description" =  "Reviews code for best practices and potential issues";
        };
      };
      "enabled_providers"= [
        "Model Prism"
      ];
      provider= {
        "Model Prism"= {
          options= {
            baseURL= "https://aic-bedrock.kollabproxy.de.dmz.tuhuk.de:8443/api/v1";
            apiKey= "bedrock";
          };
          models= {
            "model-prism"= {
              name= "model-prism";
            };
          };
        };
      };
      autoupdate = false;
      share = "disabled";
      experimental = {
        openTelemetry = false;
        mcp_timeout = 600000;
      };
    };
  };
}
