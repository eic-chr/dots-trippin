require("overseer").new_task({
  name = "NPM Dev",
  cmd = { "npm", "run", "dev" },
  components = { "default" },
}):start()
