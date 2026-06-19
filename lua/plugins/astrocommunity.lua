-- lua/plugins/astrocommunity.lua
return {
  "AstroNvim/astrocommunity",

  -- Python (pyright, ruff, black, debugpy)
  { import = "astrocommunity.pack.python" },

  -- JSON (jsonls, prettier)
  { import = "astrocommunity.pack.json" },

  -- Docker (dockerls, hadolint)
  { import = "astrocommunity.pack.docker" },

  -- Kubernetes / Helm (helm_ls)
  { import = "astrocommunity.pack.helm" },

  -- YAML (yamlls, yamllint)
  { import = "astrocommunity.pack.yaml" },

  -- Bash (bashls, shellcheck, shfmt)
  { import = "astrocommunity.pack.bash" },

  -- Go (gopls, golangci-lint, gofumpt, delve)
  { import = "astrocommunity.pack.go" },

  -- TypeScript / JavaScript (ts_ls, eslint_d, prettier)
  { import = "astrocommunity.pack.typescript" },
}
