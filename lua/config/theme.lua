-- Bridge to the active Omarchy theme.
--
-- Omarchy writes the current theme's Neovim spec to
--   ~/.local/state/omarchy/current/theme/neovim.lua
-- (legacy 3.x: ~/.config/omarchy/current/theme/neovim.lua).
--
-- Those specs are written for LazyVim: a list with the real colorscheme
-- plugin(s) plus a trailing { "LazyVim/LazyVim", opts = { colorscheme = ... } }
-- entry. We install the real plugins and apply the declared colorscheme,
-- skipping the LazyVim part. A directory watcher keeps running sessions in
-- sync when `omarchy theme set` swaps the file.

local M = {}

M.colorscheme = nil

local CANDIDATES = {
  vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua"),
  vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua"),
}

function M.path()
  for _, path in ipairs(CANDIDATES) do
    if vim.uv.fs_stat(path) then
      return path
    end
  end
end

--- Parse the state file into lazy.nvim specs + declared colorscheme name.
---@return table specs, string? colorscheme
function M.parse()
  local path = M.path()
  if not path then
    return {}, nil
  end

  local ok, specs = pcall(dofile, path)
  if not ok or type(specs) ~= "table" then
    return {}, nil
  end

  local out, colorscheme = {}, nil
  for _, spec in ipairs(specs) do
    if type(spec) == "table" and type(spec[1]) == "string" then
      if spec[1] == "LazyVim/LazyVim" then
        local opts = type(spec.opts) == "table" and spec.opts or {}
        colorscheme = type(opts.colorscheme) == "string" and opts.colorscheme or colorscheme
      else
        out[#out + 1] = spec
      end
    end
  end
  return out, colorscheme
end

--- Specs handed to lazy.nvim so the theme plugin gets installed/loaded first.
function M.specs()
  local specs, colorscheme = M.parse()
  M.colorscheme = colorscheme

  for _, spec in ipairs(specs) do
    spec.lazy = false
    spec.priority = spec.priority or 1000
  end
  return specs
end

function M.apply()
  local _, colorscheme = M.parse()
  if colorscheme and vim.g.colors_name ~= colorscheme then
    pcall(vim.cmd.colorscheme, colorscheme)
  elseif not vim.g.colors_name then
    -- Fallback: keep Neovim's default dark look until a theme exists.
    vim.o.background = "dark"
  end
end

--- Reload module cache of a loaded plugin so its setup() runs fresh.
local function unload_plugin(name)
  local ok, lazy_config = pcall(require, "lazy.core.config")
  if not ok then
    return
  end
  local plugin = lazy_config.plugins[name]
  if not (plugin and plugin._.loaded) then
    return
  end

  require("lazy.core.util").walkmods(plugin.dir .. "/lua", function(modname)
    package.loaded[modname] = nil
    package.preload[modname] = nil
  end)
  require("lazy.core.loader").reload(plugin)
end

function M.reload()
  local specs, colorscheme = M.parse()

  -- Reload every loaded theme plugin (opts may change between themes).
  for _, spec in ipairs(specs) do
    unload_plugin(spec.name or spec[1])
  end

  if colorscheme then
    pcall(vim.cmd.colorscheme, colorscheme)
  end
end

--- Watch for theme changes. We watch ~/.local/state/omarchy/current because
--- `omarchy theme set` atomically replaces the theme/ subdirectory itself.
function M.watch()
  local path = M.path()
  if not path then
    return
  end

  local dir = vim.fs.dirname(vim.fs.dirname(path))
  local timer = assert(vim.uv.new_timer())
  local event = assert(vim.uv.new_fs_event())

  event:start(dir, {}, function(err)
    if err then
      return
    end
    timer:start(200, 0, vim.schedule_wrap(M.reload))
  end)
end

return M
