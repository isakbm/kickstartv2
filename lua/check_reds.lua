vim.api.nvim_create_user_command('CheckReds', function()
  local height = vim.api.nvim_win_get_height(0)
  local num_shades = math.max(height - 4, 4)
  local colors = {}
  for idx = 0, num_shades do
    local val = string.format('%02x', (idx * 255) / num_shades)
    colors[#colors + 1] = '#' .. val .. '0000'
  end
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'win',
    row = 1,
    col = 3,
    width = 7,
    height = #colors,
    border = WIN_BORDER,
    style = 'minimal',
  })

  vim.api.nvim_set_current_win(win)
  vim.api.nvim_buf_set_lines(0, 0, 2, false, colors)
  for idx, c in ipairs(colors) do
    local rgb = string.sub(c, 2)
    local hl_name = 'ColorCheck-' .. rgb
    vim.api.nvim_set_hl(0, hl_name, { bg = c, fg = '#000000' })
    vim.api.nvim_buf_add_highlight(0, 0, hl_name, idx - 1, 0, -1)
  end
end, { desc = 'Test your colors' })
