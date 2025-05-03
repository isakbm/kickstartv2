-- Alt + j / k now glide you up and down in a nice scrolled way
--- @param dir 'j' | 'k'
return function(dir)
  local dt = 10
  local n = 10

  return function()
    local d = vim.api.nvim_get_mode()
    for i = 0, n do
      vim.fn.timer_start(i * dt, function()
        vim.api.nvim_feedkeys(dir, d.mode, false)
      end)
    end
  end
end
