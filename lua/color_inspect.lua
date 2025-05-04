--- utility to get us color and information about the
--- symbol under the cursor
return function()
  local info = vim.inspect_pos()
  local ts = info.treesitter
  local st = info.semantic_tokens

  local links = {}

  for _, sti in pairs(st) do
    if sti and sti.opts and sti.opts.hl_group_link then links[#links + 1] = sti.opts.hl_group_link end
  end

  for _, tsi in pairs(ts) do
    local link = tsi.hl_group_link
    if link then links[#links + 1] = link end
  end

  local node = vim.treesitter.get_node()
  local nt = '?'
  if node then nt = node:type() end

  for _, link in ipairs(links) do
    local hlg = vim.api.nvim_get_hl(0, { name = link })
    if hlg.fg then
      local color = string.format('%06X', hlg.fg)
      vim.fn.setreg('c', [["]] .. '#' .. color .. [["]])
      print('found color:', color, 'from', link, 'for', nt)
      break
    end
  end
end
