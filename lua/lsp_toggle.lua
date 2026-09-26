-- Written by Claude (Claude Code, Opus 5) for Isak, 2026-09-14.
--
-- Toggles LSP autostart for THIS nvim session only.
--
-- :LspStop alone does not stick -- kickstart registers one FileType autocmd per
-- server in the `lspconfig` augroup, so the next matching buffer relaunches the
-- server. This clears those triggers instead, keeping a copy so the toggle is
-- reversible without restarting nvim.
--
-- Autocmds live in process memory, so other nvim instances are unaffected.

local GROUP = 'lspconfig'

local saved = nil

return function()
  if saved then
    for _, c in ipairs(saved) do
      vim.api.nvim_create_autocmd('FileType', {
        group = c.group,
        pattern = c.pattern,
        callback = c.callback,
        desc = c.desc,
        once = c.once,
      })
    end
    vim.notify(('LSP autostart ON (%d triggers restored)'):format(#saved), vim.log.levels.INFO)
    saved = nil
    return
  end

  local ok, found = pcall(vim.api.nvim_get_autocmds, { group = GROUP, event = 'FileType' })
  if not ok then
    vim.notify('no `' .. GROUP .. '` augroup -- nothing to disable', vim.log.levels.WARN)
    return
  end

  saved = found
  vim.api.nvim_clear_autocmds({ group = GROUP, event = 'FileType' })
  for _, client in ipairs(vim.lsp.get_clients()) do
    vim.lsp.stop_client(client.id, true)
  end
  vim.notify(('LSP autostart OFF (%d triggers cleared)'):format(#saved), vim.log.levels.WARN)
end
