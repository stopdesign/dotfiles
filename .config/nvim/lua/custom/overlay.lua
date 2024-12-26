-- Create a module for the plugin
local M = {}

M.overlay = {
  buf = nil,
  win = nil,
}

-- Default options
M.opts = {}

-- Setup method for user configuration
function M.setup(opts)
  -- Merge user options with defaults
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  -- vim.notify("SETUP", vim.log.levels.INFO)
end

function M._get_or_create_overlay()
  -- Validate or create the scratch buffer
  if not (M.overlay.buf and vim.api.nvim_buf_is_valid(M.overlay.buf)) then
    M.overlay.buf = vim.api.nvim_create_buf(false, true)

    vim.bo[M.overlay.buf].buftype = "nofile"
    vim.bo[M.overlay.buf].bufhidden = "hide"
    vim.bo[M.overlay.buf].swapfile = false

    -- vim.notify("CREATE BUF: " .. tostring(M.overlay.buf), vim.log.levels.WARN)
  end

  -- Validate or create the window
  if not (M.overlay.win and vim.api.nvim_win_is_valid(M.overlay.win)) then
    local opts = {
      relative = "editor",
      width = vim.o.columns,
      height = vim.o.lines,
      row = 0,
      col = 0,
      focusable = false,
      style = "minimal",
      zindex = 10,
    }
    M.overlay.win = vim.api.nvim_open_win(M.overlay.buf, false, opts)

    -- Create highlight group if it doesn't exist
    vim.cmd("highlight default OverlayBackground guibg=#444444")

    -- Set window options
    vim.wo[M.overlay.win].winblend = 50
    vim.wo[M.overlay.win].winhighlight = "Normal:OverlayBackground"

    -- vim.notify("CREATE WIN: " .. tostring(M.overlay.win), vim.log.levels.DEBUG)
  end

  return M.overlay.buf, M.overlay.win
end

function M.show()
  M._get_or_create_overlay()
end

function M.hide()
  if M.overlay.win and vim.api.nvim_win_is_valid(M.overlay.win) then
    vim.api.nvim_win_hide(M.overlay.win)
  else
    --vim.notify("INVALID WINDOW " .. tostring(M.overlay.win) .. ", valid? " .. tostring(vim.api.nvim_win_is_valid(M.overlay.win)), vim.log.levels.ERROR)
  end
end

return M
