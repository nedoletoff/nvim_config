-- project-to-md: экспорт проекта в Markdown
-- <Leader>md — запустить (cwd → <dirname>_<timestamp>.md)
-- which-key группа <Leader>m подписана в astrocore.lua

---@type LazySpec
return {
  dir = vim.fn.expand("~"),
  name = "project-to-md",
  lazy = false,
  config = function()
    local script_path = vim.fn.stdpath("data") .. "/project_to_md/project_to_md.py"
    local script_url = "https://raw.githubusercontent.com/nedoletoff/project_to_md/main/project_to_md.py"

    local function ensure_script(callback)
      if vim.fn.filereadable(script_path) == 1 then callback(); return end
      vim.fn.mkdir(vim.fn.fnamemodify(script_path, ":h"), "p")
      vim.notify("project-to-md: downloading script...", vim.log.levels.INFO)
      vim.fn.jobstart({ "curl", "-fsSL", "-o", script_path, script_url }, {
        on_exit = function(_, code)
          if code == 0 then
            vim.notify("project-to-md: ✓ downloaded", vim.log.levels.INFO)
            callback()
          else
            vim.notify("project-to-md: ✗ download failed", vim.log.levels.ERROR)
          end
        end,
      })
    end

    local function run()
      ensure_script(function()
        local dir = vim.fn.getcwd()
        local output = dir .. "/" .. vim.fn.fnamemodify(dir, ":t") .. "_" .. os.date("%Y%m%d_%H%M%S") .. ".md"
        vim.notify("project-to-md: я приступаю...", vim.log.levels.INFO)
        vim.fn.jobstart({ "python3", script_path, dir, output }, {
          on_exit = function(_, code)
            if code == 0 then
              vim.notify("✓ " .. vim.fn.fnamemodify(output, ":t"), vim.log.levels.INFO)
            else
              vim.notify("✗ project-to-md: ошибка (" .. code .. ")", vim.log.levels.ERROR)
            end
          end,
        })
      end)
    end

    vim.keymap.set("n", "<Leader>md", run, { desc = "Project → Markdown", noremap = true, silent = true })
  end,
}
