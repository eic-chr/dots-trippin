local dap = require('dap')
-- dap.adapters.java = {
--   type = 'executable',
--   command = 'java',
--   args = {'-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005'},
-- }

--Java debugger adapter settings
dap.configurations.java = {
  {
    name = "Debug (Attach) - Remote",
    type = "java",
    request = "attach",
    hostName = "127.0.0.1",
    port = 5005,
  },
  {
    name = "Debug Non-Project class",
    type = "java",
    request = "launch",
    program = "${file}",
  },
}
