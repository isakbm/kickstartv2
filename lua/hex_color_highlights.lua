--- @type table<string, string>
local hlgs = {}

local my_ns = vim.api.nvim_create_namespace 'isaks'

--- works by searching for string of the form "#RRGGBB"
--- keeps a list of created highlght groups and reuses
--- them, ... only searches in the current visible part
--- of the buffer, and only upates on changes
local function hex_color_highlight()
  local top = vim.fn.line 'w0'
  local bot = vim.fn.line 'w$'

  local text = vim.api.nvim_buf_get_lines(0, top, bot, true)

  vim.api.nvim_buf_clear_namespace(0, my_ns, 0, -1)
  vim.api.nvim_win_set_hl_ns(0, my_ns)

  for idx, line in pairs(text) do
    local offset = 1
    for m in line:gmatch '["\']#%x%x%x%x%x%x["\']' do
      local loc = line:find(m, offset, true)
      offset = loc + 9
      local row = idx + top
      local col_start = loc
      local col_end = offset

      local hlg = false
      local sm = m:sub(3, 8)
      for _, c_hlg in pairs(hlgs) do
        if c_hlg == sm then
          hlg = true
          break
        end
      end

      if not hlg then
        vim.api.nvim_set_hl(my_ns, sm, { fg = '#' .. sm })
        hlgs[#hlgs + 1] = sm
      end

      if col_start and col_end then
        vim.api.nvim_buf_add_highlight(0, my_ns, sm, row - 1, col_start - 1, col_end - 1)
      end
    end
  end
end

vim.api.nvim_create_autocmd({ 'WinEnter', 'WinScrolled' }, {
  callback = function()
    hex_color_highlight()
  end,
})
