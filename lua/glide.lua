do
  local dt = 10
  local n = 10

  --- @param dir 'j' | 'k'
  local function glide(dir)
    return function()
      local d = vim.api.nvim_get_mode()
      for i = 0, n do
        vim.fn.timer_start(i * dt, function()
          vim.api.nvim_feedkeys(dir, d.mode, false)
        end)
      end
    end
  end

  vim.keymap.set({ 'v', 'n' }, '<M-j>', glide 'j')
  vim.keymap.set({ 'v', 'n' }, '<M-k>', glide 'k')
end
