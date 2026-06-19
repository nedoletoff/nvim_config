-- Plugin: project-to-md
-- Keybinding: <Leader>md
-- Auto-downloads project_to_md.py from GitHub on first use
-- Directory: cwd, Output: <dirname>_<timestamp>.md in cwd

---@type LazySpec
return {
  dir = vim.fn.expand("~"),
  name = "project-to-md",
  lazy = false,
  config = function()
    local script_path = vim.fn.stdpath("data") .. "/project_to_md/project_to_md.py"
    local script_url = "https://raw.githubusercontent.com/nedoletoff/project_to_md/main/project_to_md.py"

    local function ensure_script(callback)
      if vim.fn.filereadable(script_path) == 1 then
        callback()
        return
      end

      vim.fn.mkdir(vim.fn.fnamemodify(script_path, ":h"), "p")
      vim.notify("project-to-md: downloading script...", vim.log.levels.INFO)

      vim.fn.jobstart({ "curl", "-fsSL", "-o", script_path, script_url }, {
        on_exit = function(_, code)
          if code == 0 then
            vim.notify("project-to-md: script downloaded", vim.log.levels.INFO)
            callback()
          else
            vim.notify("project-to-md: failed to download script (exit " .. code .. ")", vim.log.levels.ERROR)
          end
        end,
      })
    end

    local function run_project_to_md()
      ensure_script(function()
        local dir = vim.fn.getcwd()
        local dirname = vim.fn.fnamemodify(dir, ":t")
        local timestamp = os.date("%Y%m%d_%H%M%S")
        local output = dir .. "/" .. dirname .. "_" .. timestamp .. ".md"

        local cmd = { "python3", script_path, dir, output }

        vim.notify("project-to-md: processing " .. dirname .. "...", vim.log.levels.INFO)

        vim.fn.jobstart(cmd, {
          on_exit = function(_, code)
            if code == 0 then
              vim.notify("project-to-md: done → " .. vim.fn.fnamemodify(output, ":t"), vim.log.levels.INFO)
            else
              vim.notify("project-to-md: failed (exit code " .. code .. ")", vim.log.levels.ERROR)
            end
          end,
        })
      end)
    end

    vim.keymap.set("n", "<Leader>md", run_project_to_md, { desc = "Project to Markdown", noremap = true, silent = true })
  end,
}
