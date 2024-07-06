return {
  hide_cursor = function()
    vim.cmd 'highlight Cursor blend=100'
    vim.opt.guicursor:append 'a:Cursor/lCursor'
  end,

  show_cursor = function()
    vim.cmd 'highlight clear Cursor'
    vim.opt.guicursor = vim.opt.guicursor - 'a:Cursor/lCursor'
  end,

  ---@param r number
  ---@param g number
  ---@param b number
  ---@return number, number, number
  hsl_from_rgb = function(r, g, b)
    -- Normalize the RGB values
    local r_prime = r / 255.0
    local g_prime = g / 255.0
    local b_prime = b / 255.0

    -- Find the maximum and minimum values
    local c_max = math.max(r_prime, g_prime, b_prime)
    local c_min = math.min(r_prime, g_prime, b_prime)
    local delta = c_max - c_min

    -- Calculate Lightness
    local l = (c_max + c_min) / 2

    -- Calculate Saturation
    local s = 0
    if delta == 0 then
      s = 0
    else
      s = delta / (1 - math.abs(2 * l - 1))
    end

    -- Calculate Hue
    local h = 0
    if delta == 0 then
      h = 0
    elseif c_max == r_prime then
      h = 60 * (((g_prime - b_prime) / delta) % 6)
    elseif c_max == g_prime then
      h = 60 * (((b_prime - r_prime) / delta) + 2)
    elseif c_max == b_prime then
      h = 60 * (((r_prime - g_prime) / delta) + 4)
    end

    if h < 0 then
      h = h + 360
    end

    return h, 100 * s, 100 * l
  end,

  ---@param h integer
  ---@param s integer
  ---@param l integer
  ---@return integer, integer, integer
  rgb_from_hsl = function(h, s, l)
    h = h % 360

    s = s / 100
    l = l / 100

    local c = (1 - math.abs(2 * l - 1)) * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = l - c / 2

    local rgb = { 0, 0, 0 }

    if 0 <= h and h < 60 then
      rgb = { c, x, 0 }
    elseif 60 <= h and h < 120 then
      rgb = { x, c, 0 }
    elseif 120 <= h and h < 180 then
      rgb = { 0, c, x }
    elseif 180 <= h and h < 240 then
      rgb = { 0, x, c }
    elseif 240 <= h and h < 300 then
      rgb = { x, 0, c }
    elseif 300 <= h and h < 360 then
      rgb = { c, 0, x }
    else
      rgb = { 0, 0, 0 } -- Should not happen
    end

    --  Convert to RGB and scale to [0, 255]
    for i = 1, 3 do
      rgb[i] = (rgb[i] + m) * 255
    end

    return rgb[1], rgb[2], rgb[3]
  end,
}
