-- lua/plugins/astrocommunity.lua
return {
  "AstroNvim/astrocommunity",
  
  -- Python (установит pyright, ruff, black, debugpy)
  { import = "astrocommunity.pack.python" },
  
  -- JSON (jsonls, jq/prettier)
  { import = "astrocommunity.pack.json" },
  
  -- Docker (dockerls, hadolint)
  { import = "astrocommunity.pack.docker" },
  
  -- Kubernetes и YAML (yamlls, helm_ls)
  { import = "astrocommunity.pack.helm" },
  { import = "astrocommunity.pack.yaml" },
  
  -- Bash (bashls, shellcheck, shfmt)
  { import = "astrocommunity.pack.bash" },
  
  -- Go (gopls, golangci-lint, gofumpt, delve)
  { import = "astrocommunity.pack.go" },
  
  -- Java (jdtls, google-java-format, java-debug-adapter)
  { import = "astrocommunity.pack.java" },
  
  -- C / C++ (clangd, cpplint, codelldb)
  { import = "astrocommunity.pack.cpp" },
  
  -- JS / TS (ts_ls, eslint_d, prettier, js-debug-adapter)
  { import = "astrocommunity.pack.typescript" },
}
