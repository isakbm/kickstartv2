local C = require 'coleur'

return {
  ---@param on_update fun(colors: table<string, string>)
  ---@param colorPalette string
  color_edit_ui = function(on_update, colorPalette)
    local cp = require(colorPalette)

    local palette = C.Palette:new(cp)

    ---@type string[]
    local color_names = {}

    for name, _ in pairs(cp) do
      color_names[#color_names + 1] = name
    end

    vim.ui.select(color_names, {
      prompt = 'color:',
      format_item = function(item)
        return item
      end,
    }, function(name)
      if name == nil then
        return
      end

      local colorHex = cp[name]

      if colorHex == nil then
        return
      end

      local color = C.Color:from_hex(colorHex)

      local on_update = function()
        cp[name] = color:to_hex()
        on_update(cp)
        -- update_highlights(c, theme, { clear = false })
      end

      local height = vim.api.nvim_win_get_height(0)
      local width = vim.api.nvim_win_get_width(0)

      -- create the three side by side rgb channel windows
      local row = math.floor((math.max(math.floor(height / 2), 5)) / 2)

      local rgb_wins = palette:new_rgb_win_arr(color, on_update, row, width)
      local hsl_wins = palette:new_hsl_win_arr(color, on_update, row + 5, width)

      local preview_wins = palette:new_color_preview(color, row + 10, width)

      ---@type number[]
      local windows = {}
      vim.list_extend(windows, rgb_wins)
      vim.list_extend(windows, hsl_wins)
      vim.list_extend(windows, preview_wins)

      -- closing
      for _, win in pairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        vim.keymap.set('n', '<Esc><Esc>', function()
          -- delete autocommand
          vim.api.nvim_exec_autocmds('User', {
            pattern = 'ColorPaletteUpdate',
            data = 'delete',
          })

          for _, w in pairs(windows) do
            vim.api.nvim_win_close(w, true)
          end

          -- persist the colors
          do
            local file = vim.api.nvim_get_runtime_file('**/' .. colorPalette .. '.*', false)[1]

            if file == nil then
              return
            end

            local f = io.open(file, 'w')
            if not f then
              return
            end
            f:write '---@type table<string, string>\n'
            f:write 'local c = {\n'

            -- sort colors by hue
            local ordered = {}
            for name, color in pairs(cp) do
              ordered[#ordered + 1] = { name = name, color = color }
            end

            table.sort(ordered, function(a, b)
              local ca = C.Color:from_hex(a.color)
              local cb = C.Color:from_hex(b.color)
              return ca:get 'h' > cb:get 'h'
            end)

            for _, kv in ipairs(ordered) do
              f:write('  ' .. kv.name .. ' = ' .. '"' .. kv.color .. '",\n')
            end

            f:write '}\nreturn c'
            f:close()
          end
        end, { desc = 'Close highlight group editor', buffer = buf })
      end

      -- switching between the channels with ALT #
      do
        --- @param wins number[]
        local keymap_channel_switcher_for = function(wins)
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            for j, owin in ipairs(wins) do
              vim.keymap.set('n', '<M-' .. j .. '>', function()
                vim.api.nvim_set_current_win(owin)
              end, { desc = 'Goto channel ' .. j, buffer = buf })
            end
          end
        end

        keymap_channel_switcher_for(rgb_wins)
        keymap_channel_switcher_for(hsl_wins)
      end

      -- switching between RGB or HSL
      do
        ---@param a number[]
        ---@param b number[]
        local keymap_jump_win_arrays = function(a, b)
          for _, win in pairs(a) do
            local buf = vim.api.nvim_win_get_buf(win)
            vim.keymap.set('n', '<Tab>', function()
              vim.api.nvim_set_current_win(b[1])
            end, { buffer = buf, desc = 'Jump between RGB <-> HSL' })
          end
        end

        keymap_jump_win_arrays(rgb_wins, hsl_wins)
        keymap_jump_win_arrays(hsl_wins, rgb_wins)
      end

      -- set active window to the red channel
      vim.api.nvim_set_current_win(rgb_wins[1])
    end)
  end,
}
