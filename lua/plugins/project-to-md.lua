-- Plugin: project-to-md
-- Keybinding: <Leader>pm
-- Prompts for directory and output filename, then runs project_to_md.py

---@type LazySpec
return {
  dir = vim.fn.expand("~"),  -- dummy local "plugin" (no external repo needed)
  name = "project-to-md",
  lazy = false,
  config = function()
    local function run_project_to_md()
      -- Suggest current working directory as default
      local default_dir = vim.fn.getcwd()

      vim.ui.input({ prompt = "Project directory: ", default = default_dir, completion = "dir" }, function(dir)
        if not dir or dir == "" then
          vim.notify("project-to-md: directory not specified", vim.log.levels.WARN)
          return
        end

        vim.ui.input({ prompt = "Output filename (.md): ", default = "output.md" }, function(output)
          if not output or output == "" then
            vim.notify("project-to-md: output filename not specified", vim.log.levels.WARN)
            return
          end

          -- Ensure .md extension
          if not output:match("%.md$") then
            output = output .. ".md"
          end

          local script = vim.fn.expand("~/projects/project_to_md/project_to_md.py")
          local cmd = string.format("python3 %s %s %s", vim.fn.shellescape(script), vim.fn.shellescape(dir), vim.fn.shellescape(output))

          vim.notify("project-to-md: running...", vim.log.levels.INFO)

          vim.fn.jobstart(cmd, {
            on_exit = function(_, code)
              if code == 0 then
                vim.notify("project-to-md: done → " .. output, vim.log.levels.INFO)
              else
                vim.notify("project-to-md: failed (exit code " .. code .. ")", vim.log.levels.ERROR)
              end
            end,
          })
        end)
      end)
    end

    vim.keymap.set("n", "<Leader>pm", run_project_to_md, { desc = "Project to Markdown", noremap = true, silent = true })
  end,
}
