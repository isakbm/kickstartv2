--- like * but doesn't move you around
--- vim.keymap.set('n', '*', require("nice-star"), { desc = 'highlight all occurrences of current word' })
return function()
  -- NOTE yes this a bit convoluted, but avoids issues with the old way ... the old way would sometimes change
  --      scroll position of buffer if scrolloff is set
  --
  -- OLD WAY
  --
  --      vim.keymap.set('n', '*', '/<C-R><C-W><cr>N', { desc = 'highlight all occurrences of current word' })
  --
  local word = vim.fn.expand('<cword>')
  local pattern = [[\C\<]] .. word .. [[\>]] -- pattern to match full word only
  vim.fn.setreg('/', pattern)
  vim.opt.hlsearch = true
  vim.fn.searchcount({ recompute = 1 })
end
