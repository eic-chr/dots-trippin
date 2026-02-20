return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      nix = { "statix" },
      asciidoc = { "vale" },
    },
  },
}
