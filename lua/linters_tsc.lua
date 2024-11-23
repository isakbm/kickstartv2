---@type LinterShim
return {
  name = 'tsc',
  cmd = 'npx',
  args = { 'tsc', '--noEmit', 'true', '--pretty', 'false' },

  res_to_diagnostics = function(res, set_file_diagnostics, _on_err)
    ---@type table<string, vim.Diagnostic[]>
    local f_diagnostics = {}

    for line in res:gmatch '[^\r\n]+' do
      local filename, lnum, col, code, message = line:match '^(.+)%((%d+),(%d+)%)%s*:%s*(.+):%s*(.+)$'
      if f_diagnostics[filename] == nil then
        f_diagnostics[filename] = {}
      end
      f_diagnostics[filename][#f_diagnostics[filename] + 1] = {
        lnum = lnum and (lnum - 1) or 0,
        end_lnum = nil,
        col = col and (col - 1) or 0,
        end_col = nil,
        message = message and message or '?',
        code = code and code or nil,
        severity = 1,
        source = 'tsc',
      }
    end

    for file, diagnostics in pairs(f_diagnostics) do
      vim.schedule(function()
        set_file_diagnostics(file, diagnostics)
      end)
    end
  end,
}
