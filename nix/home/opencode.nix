{ ... }: {
  programs.opencode = {
    enable = true;
    settings = {
      autoupdate = false;
      share = "disabled";
      experimental = {
        openTelemetry = false;
        mcp_timeout = 600000;
      };
      provider = {
        openai-compatible = {
          npm = "@ai-sdk/openai-compatible";
          name = "HUK Provider";
          options = {
            baseURL =
              "https://openwebui.kollabproxy.de.dmz.tuhuk.de:8443/api/v1";
          };
          models = {
            "aws.eu.anthropic.claude-sonnet-4-20250514-v1:0" = {
              name = "aws.claude-sonnet-4-20250514-v1:0";
            };
            "aws.eu.anthropic.claude-opus-4-6-v1" = {
              name = "aws.eu.anthropic.claude-opus-4-6-v1";
            };
            "aws.eu.anthropic.claude-sonnet-4-6" = {
              name = "aws.eu.anthropic.claude-sonnet-4-6";
            };
            gpt5 = { name = "gpt5"; };
          };
        };
      };
    };
  };

}
