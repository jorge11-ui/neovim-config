local function get_fonts()
  local handle = io.popen("fc-list :spacing=mono family | sort -u | grep -i 'nerd font'")
  if not handle then
    return {}
  end
  local result = handle:read("*a")
  handle:close()

  local fonts = {}
  for line in result:gmatch("[^\r\n]+") do
    local font = line:match("^%s*(.-)%s*$")
    if font and font ~= "" then
      table.insert(fonts, font)
    end
  end
  return fonts
end

local function get_current_font()
  local config = io.open(os.getenv("HOME") .. "/.config/alacritty/alacritty.toml", "r")
  if not config then
    return ""
  end
  local content = config:read("*a")
  config:close()

  local current = content:match('normal%s*=%s*{[^}]*family%s*=%s*"([^"]+)"')
  return current or ""
end

local function set_font(font_name)
  local config_path = os.getenv("HOME") .. "/.config/alacritty/alacritty.toml"
  local config = io.open(config_path, "r")
  if not config then
    vim.notify("Could not open alacritty.toml", vim.log.levels.ERROR)
    return
  end
  local content = config:read("*a")
  config:close()

  local new_content = content:gsub(
    '(normal%s*=%s*{[^}]*family%s*=%s*")[^"]+(")',
    '%1' .. font_name .. '%2'
  )
  new_content = new_content:gsub(
    '(bold%s*=%s*{[^}]*family%s*=%s*")[^"]+(")',
    '%1' .. font_name .. '%2'
  )
  new_content = new_content:gsub(
    '(italic%s*=%s*{[^}]*family%s*=%s*")[^"]+(")',
    '%1' .. font_name .. '%2'
  )

  config = io.open(config_path, "w")
  if not config then
    vim.notify("Could not write alacritty.toml", vim.log.levels.ERROR)
    return
  end
  config:write(new_content)
  config:close()

  vim.notify("Font changed to: " .. font_name, vim.log.levels.INFO)

  local ret = os.execute(
    string.format('alacritty msg config \'font.normal.family="%s"\' \'font.bold.family="%s"\' \'font.italic.family="%s"\' 2>/dev/null', font_name, font_name, font_name)
  )
  if ret ~= 0 then
    vim.notify("Restart Alacritty to apply the new font", vim.log.levels.INFO)
  end
end

local function open_font_picker()
  local fonts = get_fonts()
  if #fonts == 0 then
    vim.notify("No monospace fonts found", vim.log.levels.WARN)
    return
  end

  local current = get_current_font()

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "Fonts (current: " .. current .. ")",
      finder = finders.new_table({
        results = fonts,
        entry_maker = function(entry)
          local display = entry
          if entry == current then
            display = entry .. " [current]"
          end
          return {
            value = entry,
            display = display,
            ordinal = entry,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            set_font(selection.value)
          end
        end)
        return true
      end,
    })
    :find()
end

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<leader>ç", function() open_font_picker() end, desc = "Change font" },
    },
  },
}
