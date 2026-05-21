-- Git integration with Gitsigns
-- Provides inline git diff, blame, and hunk operations

return {
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          -- Navigation between hunks
          map("n", "]h", gs.next_hunk, "Next git hunk")
          map("n", "[h", gs.prev_hunk, "Previous git hunk")

          -- Actions
          map("n", "<leader>gh", gs.preview_hunk, "Preview git hunk")
          map("n", "<leader>gH", gs.preview_hunk_inline, "Preview git hunk inline")
          map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Git blame line")
          map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle git blame line")
          map("n", "<leader>gd", gs.diffthis, "Git diff")
          
          -- Hunk operations
          map("n", "<leader>gr", gs.reset_hunk, "Reset hunk (откатить изменения)")
          map("v", "<leader>gr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selected hunks")
          map("n", "<leader>gR", gs.reset_buffer, "Reset buffer (откатить весь файл)")
          map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
          map("v", "<leader>gs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selected hunks")
          map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
          map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")

          -- Text object for hunks
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Git hunk text object")
        end,
      })
    end,
  },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      -- Leader key mappings
      maps.n["<leader>g"] = { desc = "󰊢 Git" }
    end,
  },
}
