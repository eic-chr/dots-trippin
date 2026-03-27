-- lua/plugins/dirdiff.lua
return {
  "ZSaberLv0/ZFVimDirDiff",
  dependencies = { "ZSaberLv0/ZFVimJob" },
  cmd = "ZFDirDiff",
  keys = {
    { "<leader>fd", ":ZFDirDiff ", desc = "Dir Diff" },
  },
}
