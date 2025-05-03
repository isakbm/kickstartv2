--- Fun little utility to places boxes around visually selected lines of text
return function()
  local buf = vim.api.nvim_get_current_buf()

  local _, start_line, _, _ = unpack(vim.fn.getpos('v'))
  local _, end_line, _, _ = unpack(vim.fn.getpos('.'))

  -- handle reversed selection
  if start_line > end_line then
    local sep = start_line - end_line
    start_line = end_line
    end_line = start_line + sep
  end

  local lines = vim.api.nvim_buf_get_text(buf, start_line - 1, 0, end_line - 1, -1, {})

  -- set box width to max line width
  local max_width = 0
  for _, line in pairs(lines) do
    if max_width < string.len(line) then
      max_width = string.len(line)
    end
  end

  -- box in the lines
  local box_width = max_width
  local box_indent = string.rep(' ', 4)

  local boxed_lines = { [1] = box_indent .. '╭' .. string.rep('─', box_width + 2) .. '╮' }
  for i, line in pairs(lines) do
    print('LINE:' .. line)
    local line_width = #line
    if line_width < box_width then
      -- lines[i] = '| ' .. line .. string.rep(' ', box_width - line_width) .. ' |'
      boxed_lines[i + 1] = box_indent .. '│ ' .. line .. string.rep(' ', box_width - line_width) .. ' │'
    else
      -- lines[i] = '| ' .. line .. ' |'
      boxed_lines[i + 1] = box_indent .. '│ ' .. line .. ' │'
    end
  end

  boxed_lines[#boxed_lines + 1] = box_indent .. '╰' .. string.rep('─', box_width + 2) .. '╯'

  -- simulate hitting the esc key to go into normal mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)

  -- vim.api.nvim_buf_set_lines(buf, start_line, end_line + 1, false, { 'hello world' })
  vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, boxed_lines)
end
