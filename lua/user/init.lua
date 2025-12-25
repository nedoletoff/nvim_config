-- Load Python healthcheck
require("user.python_healthcheck")

-- Register custom health checks
vim.health.register_check("python3", require("user.python_healthcheck").check)
