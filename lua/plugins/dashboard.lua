-- Start screen: alpha-nvim, dark centered layout with pixel NEOVIM art.
-- mini.nvim stays loaded only for editing QoL modules (no dashboard role).

return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    lazy = false,
    priority = 900,
    config = function()
      -- Autopairs (not autocomplete).
      require("mini.pairs").setup()

      -- Surround: sa/sd/sr/sf. :h mini.surround
      require("mini.surround").setup({
        mappings = {
          add = "sa",
          delete = "sd",
          find = "sf",
          find_left = "sF",
          highlight = "sh",
          replace = "sr",
          update_n_lines = "sn",
        },
      })

      -- Extended textobjects: ciq, cia, cif... :h MiniAi-textobjects
      require("mini.ai").setup()

      -- Move lines/selection with Alt+hjkl.
      require("mini.move").setup({
        mappings = {
          left = "<A-h>",
          right = "<A-l>",
          down = "<A-j>",
          up = "<A-k>",
          line_left = "<A-h>",
          line_right = "<A-l>",
          line_down = "<A-j>",
          line_up = "<A-k>",
        },
      })
    end,
  },

  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Expose the alpha dashboard object so the LazyVim snacks_picker extra can
    -- call dashboard.button() when adding its "Projects" entry.
    opts = function()
      return require("alpha.themes.dashboard")
    end,
    config = function()
      local alpha = require("alpha")

      -- Dark, theme-independent palette so the start screen stays muted
      -- even under colorful or grayscale Omarchy colorschemes.
      local function apply_dashboard_hl()
        local bg = "#0a0a0a"
        vim.api.nvim_set_hl(0, "DashboardNormal", { fg = "#b0b0b0", bg = bg })
        vim.api.nvim_set_hl(0, "DashboardTitle", { fg = "#c8c8c8", bg = bg, bold = true })
        vim.api.nvim_set_hl(0, "DashboardMuted", { fg = "#555555", bg = bg })
        vim.api.nvim_set_hl(0, "DashboardButton", { fg = "#8a8a8a", bg = bg })
        vim.api.nvim_set_hl(0, "DashboardShortcut", { fg = "#3f3f3f", bg = bg })
      end
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("dashboard_hl", { clear = true }),
        callback = apply_dashboard_hl,
      })
      apply_dashboard_hl()

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dashboard_dark", { clear = true }),
        pattern = "alpha",
        callback = function()
          vim.opt_local.winhighlight = "Normal:DashboardNormal,NormalNC:DashboardNormal,EndOfBuffer:DashboardNormal"
        end,
      })

      -- Pixel-block NEOVIM: 5x5 bitmap, no box-drawing.
      local art = {
        "█   █ █████  ███  █   █ █████ █   █",
        "██  █ █     █   █ █   █   █   ██ ██",
        "█ █ █ ████  █   █ █   █   █   █ █ █",
        "█  ██ █     █   █  █ █    █   █   █",
        "█   █ █████  ███    █   █████ █   █",
      }

      local items = {
        { key = "n", icon = "", label = "New File", shortcut = "<leader>n", cmd = ":enew<CR>" },
        { key = "f", icon = "", label = "Find File", shortcut = "<leader>ff", cmd = ":Telescope find_files<CR>" },
        { key = "r", icon = "", label = "Recent Files", shortcut = "<leader>fr", cmd = ":Telescope oldfiles<CR>" },
        { key = "g", icon = "󰊄", label = "Find Text", shortcut = "<leader>fg", cmd = ":Telescope live_grep<CR>" },
        { key = "c", icon = "", label = "Configuration", shortcut = "<leader>c", cmd = ":edit $MYVIMRC<CR>" },
        { key = "p", icon = "󰏗", label = "Plugins", shortcut = "<leader>p", cmd = ":Lazy<CR>" },
        { key = "q", icon = "󰈆", label = "Quit", shortcut = "<leader>q", cmd = ":confirm q<CR>" },
      }

      local label_width = 13 -- len("Configuration")
      -- icon(1) + 2sp + label column + 6sp gap + shortcut + breathing room
      local button_width = 3 + label_width + 6 + #("<leader>ff") + 2

      -- Same shape alpha.themes.dashboard builds internally, with our own
      -- display opts (dimmed right-aligned shortcuts) kept out of keymaps.
      local function button(item)
        local pad = item.label .. string.rep(" ", label_width - #item.label)
        return {
          type = "button",
          val = item.icon .. "  " .. pad,
          on_press = function()
            local key = vim.api.nvim_replace_termcodes(item.cmd, true, false, true)
            vim.api.nvim_feedkeys(key, "t", false)
          end,
          opts = {
            position = "center",
            cursor = 3,
            shortcut = item.shortcut,
            width = button_width,
            align_shortcut = "right",
            hl = "DashboardButton",
            hl_shortcut = "DashboardShortcut",
            keymap = { "n", item.key, item.cmd, { noremap = true, silent = true, nowait = true } },
          },
        }
      end

      local buttons = vim.tbl_map(button, items)

      -- Content height below the top padding: art(5) + gap(1) + date/time(2)
      -- + gap(1) + menu(7) + gap(1) + footer(1). Recomputed per render so
      -- every terminal size gets true vertical centering.
      local content_height = 18

      local art_width = vim.api.nvim_strwidth(art[1])

      local function header_lines()
        local out = {}
        local avail = vim.o.lines - vim.o.cmdheight - 1 -- global statusline row
        local pad = math.max(math.floor((avail - content_height) / 2) - 2, 1)
        for _ = 1, pad do
          out[#out + 1] = ""
        end
        if vim.o.columns >= art_width + 4 then
          vim.list_extend(out, art)
        else
          out[#out + 1] = "NEOVIM" -- tiny terminals
        end
        return out
      end

      local function datetime_lines()
        return {
          "",
          os.date("󰃭  %A, %d %B %Y"),
          string.rep("─", 14) .. "  " .. os.date("%H:%M") .. "  " .. string.rep("─", 14),
          "",
        }
      end

      local function footer_lines()
        local bufs = 0
        for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
          if vim.bo[buf.bufnr].filetype ~= "alpha" then
            bufs = bufs + 1
          end
        end
        local errors, warnings = 0, 0
        for _, diag in ipairs(vim.diagnostic.get()) do
          if diag.severity == vim.diagnostic.severity.ERROR then
            errors = errors + 1
          elseif diag.severity == vim.diagnostic.severity.WARN then
            warnings = warnings + 1
          end
        end
        local v = vim.version()
        return {
          "",
          string.format(
            "v%d.%d.%d   buffers %d   warnings %d   errors %d",
            v.major,
            v.minor,
            v.patch,
            bufs,
            warnings,
            errors
          ),
        }
      end

      alpha.setup({
        layout = {
          { type = "text", val = header_lines, opts = { position = "center", hl = "DashboardTitle" } },
          { type = "text", val = datetime_lines, opts = { position = "center", hl = "DashboardMuted" } },
          { type = "group", val = buttons, opts = { spacing = 0 } },
          { type = "text", val = footer_lines, opts = { position = "center", hl = "DashboardMuted" } },
        },
        opts = {},
      })

      if vim.bo.filetype == "alpha" then
        vim.opt_local.winhighlight = "Normal:DashboardNormal,NormalNC:DashboardNormal,EndOfBuffer:DashboardNormal"
      end

      -- Live clock: refresh date/time while the start screen is focused.
      local timer = assert(vim.uv.new_timer())
      timer:start(20000, 20000, vim.schedule_wrap(function()
        if vim.bo.filetype == "alpha" then
          pcall(function()
            alpha.redraw()
          end)
        end
      end))

      vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("dashboard_clock", { clear = true }),
        callback = function()
          if vim.bo.filetype == "alpha" then
            pcall(function()
              alpha.redraw()
            end)
          end
        end,
      })
    end,
  },
}
