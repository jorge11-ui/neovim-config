-- Native floating/split terminal with a single reusable buffer.
-- No plugin needed: opens lazily, hides instead of dying, remembers cwd.

local M = {}

local state = { buf = -1, win = -1 }

local function project_root()
  local file = vim.api.nvim_buf_get_name(0)
  local from = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
  local root = vim.fs.find({ ".git", "Makefile", "package.json" }, {
    upward = true,
    path = from,
    stop = vim.uv.os_homedir(),
  })[1]
  if not root then
    return vim.uv.cwd()
  end
  return vim.fn.isdirectory(root) == 1 and root or vim.fs.dirname(root)
end

local function create_win()
  local width = math.floor(vim.o.columns * 0.85)
  local height = math.floor(vim.o.lines * 0.8)
  local buf = state.buf

  state.win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2) + 1,
    border = "single",
    title = " terminal ",
    title_pos = "center",
  })
  vim.wo[state.win].winblend = 0
  vim.bo[buf].bufhidden = ""
end

function M.open()
  if not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.buf].bufhidden = ""
    vim.api.nvim_buf_set_keymap(state.buf, "t", "<Esc><Esc>", [[<C-\><C-n>]], { silent = true })
  end

  if vim.api.nvim_win_is_valid(state.win) then
    return
  end

  create_win()
  vim.cmd("startinsert!")

  -- Start the job on first open, inside the project root.
  if vim.b[state.buf].terminal_started then
    return
  end
  vim.b[state.buf].terminal_started = true

  vim.fn.jobstart({ vim.o.shell }, {
    term = true,
    cwd = project_root(),
    detach = true,
    on_exit = function()
      pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
      state.buf = -1
      state.win = -1
    end,
  })
end

function M.close()
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    state.win = -1
  end
end

function M.toggle()
  if vim.api.nvim_win_is_valid(state.win) and vim.api.nvim_get_current_win() == state.win then
    M.close()
    return
  end
  M.open()
end

--- Run a one-off command (e.g. lazygit) in a floating terminal window.
---@param cmd string[]
---@param opts? { title?: string, keymaps?: boolean }
function M.float_run(cmd, opts)
  opts = opts or {}
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    border = "single",
    title = opts.title and (" " .. opts.title .. " ") or nil,
    title_pos = "center",
  })

  vim.wo[win].winblend = 0
  vim.bo[buf].bufhidden = "wipe"

  vim.fn.jobstart(cmd, {
    term = true,
    detach = false,
    on_exit = function(_, code)
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      if code ~= 0 then
        vim.notify(cmd[1] .. " exited with " .. code, vim.log.levels.WARN)
      end
    end,
  })

  vim.cmd("startinsert")
end

return M
