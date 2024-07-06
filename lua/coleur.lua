local ut = require 'utils'

----------------------------------------------------------------

---@class Palette.Color
---@field r number
---@field g number
---@field b number
local Color = {}
Color.__index = Color

--- new default color "black"
function Color:new()
  local color = setmetatable({}, Color)
  color.r = 0
  color.g = 0
  color.b = 0
  return color
end

--- from rgb
---@param r number
---@param g number
---@param b number
function Color:from_rgb(r, g, b)
  local color = Color:new()
  color.r = r
  color.g = g
  color.b = b
  return color
end

--- from hex string like '#005F00'
--- @param hex string
function Color:from_hex(hex)
  local r = tonumber(hex:sub(2):sub(1, 2), 16)
  local g = tonumber(hex:sub(2):sub(3, 4), 16)
  local b = tonumber(hex:sub(2):sub(5, 6), 16)
  return Color:from_rgb(r, g, b)
end

--- returns hex string like '#005F00'
--- @return string
function Color:to_hex()
  local r, g, b = self:get_rgb()
  local function fmt(v)
    return string.format('%02x', v)
  end
  return '#' .. fmt(r) .. fmt(g) .. fmt(b)
end

--- get rgb tuple
--- @return integer, integer, integer
function Color:get_rgb()
  return self.r, self.g, self.b
end

--- get hsl tuple
--- @return integer, integer, integer
function Color:get_hsl()
  local r, g, b = self:get_rgb()
  local h, s, l = ut.hsl_from_rgb(r, g, b)
  return h, s, l
end

--- get scalar like r, g, b, h, s, l
--- @param scalar 'r'| 'g'| 'b'| 'h'| 's'| 'l'
--- @return integer
function Color:get(scalar)
  local r, g, b = self:get_rgb()
  local h, s, l = self:get_hsl()
  return ({ r = r, g = g, b = b, h = h, s = s, l = l })[scalar]
end

--- get scalar like r, g, b, h, s, l
--- @param scalar 'r'| 'g'| 'b'| 'h'| 's'| 'l'
--- @param value integer
function Color:set(scalar, value)
  if scalar == 'r' or scalar == 'g' or scalar == 'b' then
    self[scalar] = value
    return
  end

  local h, s, l = self:get_hsl()
  if scalar == 'h' then
    h = value
  elseif scalar == 's' then
    s = value
  elseif scalar == 'l' then
    l = value
  end

  local r, g, b = ut.rgb_from_hsl(h, s, l)
  self.r = r
  self.g = g
  self.b = b
end

----------------------------------------------------------------

---@class Palette
---@field colors table<string, string>
local Palette = {}
Palette.__index = Palette

---@param colors table<string, string>
function Palette:new(colors)
  local palette = setmetatable({}, Palette)
  palette.colors = colors
  return palette
end

-- create the three side by side rgb channel windows
---@param color Palette.Color
---@param on_update function
---@param row number
---@param avail_width number
---@return number[]
function Palette:new_rgb_win_arr(color, on_update, row, avail_width)
  local rgb_win = {}
  for idx, chan in ipairs { 'r', 'g', 'b' } do
    local col = idx * 5 + avail_width / 2
    rgb_win[#rgb_win + 1] = self.new_floating_chan_win(color, on_update, row, col, 3, chan, 0, 255, 'rgb')
  end
  return rgb_win
end

-- create the three side by side rgb channel windows
---@param color Palette.Color
---@param on_update function
---@param row number
---@param avail_width number
---@return number[]
function Palette:new_hsl_win_arr(color, on_update, row, avail_width)
  local col = {}
  for i = 1, 3 do
    col[i] = i * 5 + avail_width / 2
  end

  local width = 3

  return {
    self.new_floating_chan_win(color, on_update, row, col[1], width, 'h', 0, 360, 'hsl'),
    self.new_floating_chan_win(color, on_update, row, col[2], width, 's', 0, 100, 'hsl'),
    self.new_floating_chan_win(color, on_update, row, col[3], width, 'l', 0, 100, 'hsl'),
  }
end

---@param color Palette.Color
---@param on_update function
---@param row integer
---@param col integer
---@param width integer
---@param channel "r" | "g" | "b" | "h" | "s"  | "l"
---@param min integer
---@param max integer
---@param group "rgb" | "hsl"
---@return integer
function Palette.new_floating_chan_win(color, on_update, row, col, width, channel, min, max, group)
  assert(max > min)
  assert(min >= 0)
  assert(row >= 0 and col >= 0, 'bad row or column arg')
  assert(width > 0, 'bad width')

  ---@param win integer
  local function cursor_update(win)
    -- set the cursor at old color position
    ---@type integer
    local v = math.min(math.floor(color:get(channel)), max - min)
    vim.api.nvim_win_set_cursor(win, { v + 1, 0 })
  end

  ---@type integer[]
  local values = {}
  for idx = min, max do
    values[#values + 1] = idx
  end

  ---@type string[]
  local labels = {}
  for _, v in pairs(values) do
    labels[#labels + 1] = string.format('%03d', v)
  end

  local colors = {}
  for _, v in pairs(values) do
    colors[#colors + 1] = ({
      r = Color:from_rgb(v, 0, 0):to_hex(),
      g = Color:from_rgb(0, v, 0):to_hex(),
      b = Color:from_rgb(0, 0, v):to_hex(),
    })[channel]
  end

  local buf = vim.api.nvim_create_buf(false, true)
  local win_title = ' ' .. channel .. ' '
  local win = vim.api.nvim_open_win(buf, false, {
    relative = 'win',
    row = row,
    col = col,
    width = width,
    height = 1,
    border = WIN_BORDER,
    style = 'minimal',
    title = { { win_title, 'ColorEditTitle' } },
    title_pos = 'center',
  })

  -- update cursor position if color has updated
  vim.api.nvim_create_autocmd('User', {
    pattern = 'ColorPaletteUpdate',
    callback = function(event)
      if event.data and event.data == 'delete' then
        -- yes if an autocommand returns a truthy value then it deletes
        -- itself, so we just say "deleted"
        return 'deleted'
      end

      -- ignore inside own colorspace
      if event.data and event.data.channel and event.data.channel == channel then
        return
      end

      cursor_update(win)
    end,
  })

  vim.api.nvim_buf_set_lines(buf, 0, 2, false, labels)

  -- color the values
  for idx, c in ipairs(colors) do
    local rgb = string.sub(c, 2)
    local hl_name = 'ColorTheme-R-' .. rgb
    local sh = idx > (255 / 2) and '00' or '99'
    local fg = '#' .. sh .. sh .. sh
    vim.api.nvim_set_hl(0, hl_name, { bg = c, fg = fg })
    vim.api.nvim_buf_add_highlight(buf, 0, hl_name, idx - 1, 0, -1)
  end

  cursor_update(win)

  -- update the highlight group when the color value is changed
  vim.api.nvim_create_autocmd('CursorMoved', {
    callback = function()
      local row = vim.api.nvim_win_get_cursor(win)[1]
      print('updating: ', channel, 'to', values[row])
      local val = values[row]
      -- prevent accidentally setting completely black using HSL
      -- why ? because otherwise you'll get very annoyed at losing
      -- other HSL values as inevitably it all defaults over to 0, 0, 0
      if (channel == 's' or channel == 'l') and val == 0 then
        val = 1
        vim.api.nvim_feedkeys('j', 'n', false)
      end
      color:set(channel, val)
      on_update()

      vim.api.nvim_exec_autocmds('User', { pattern = 'ColorPaletteUpdate', data = { channel = channel } })
      ut.hide_cursor()
    end,
    buffer = buf,
  })

  -- change title highlight when entering channel window to indicate
  -- that this is actively being edited
  do
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        vim.api.nvim_win_set_config(win, { title = { { win_title, 'ColorEditTitleActive' } } })
      end,
      buffer = buf,
    })
    vim.api.nvim_create_autocmd('BufLeave', {
      callback = function()
        vim.api.nvim_win_set_config(win, { title = { { win_title, 'ColorEditTitle' } } })
      end,
      buffer = buf,
    })
  end

  do
    -- hid cursor when in the color channel editor windows
    vim.api.nvim_create_autocmd('BufEnter', { callback = ut.hide_cursor, buffer = buf })
    vim.api.nvim_create_autocmd('BufLeave', { callback = ut.show_cursor, buffer = buf })
  end

  return win
end

---@type table<string, Palette|Palette.Color>
return {
  Palette = Palette,
  Color = Color,
}
