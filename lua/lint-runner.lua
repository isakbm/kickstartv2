---@class LinterShim
---@field name string
---@field cmd string
---@field args string[]
---@field res_to_diagnostics fun(res: string, set_file_diagnostics: fun(file: string, diagnostics: vim.Diagnostic[]), on_err: fun(msg: string))

local linter_ns = vim.api.nvim_create_namespace 'linter-runner'

return {

  ---@param linter LinterShim
  run_linter = function(linter)
    local progress = require 'fidget.progress'

    local p_handle = progress.handle.create {
      title = '',
      message = 'Launching ...',
      lsp_client = { name = linter.name },
    }

    local uv = vim.loop

    local chunks = {}
    local err_chunks = {}

    local stdout = uv.new_pipe()
    local stderr = uv.new_pipe()

    uv.spawn(linter.cmd, {
      args = linter.args,
      stdio = { nil, stdout, stderr },
    }, function(code, signal)
      -- on exit
    end)

    uv.read_start(stdout, function(err, data)
      assert(not err, err)
      if data then
        p_handle.message = 'Processing stdout ...'
        -- read data from stdout
        chunks[#chunks + 1] = data
      else
        -- stdout stream ended
        local res = table.concat(chunks, '')
        linter.res_to_diagnostics(res, function(file, diagnostics)
          p_handle.message = 'Updating diagnostics ...'
          local buf = vim.fn.bufnr(file, true)
          vim.fn.bufload(buf)
          vim.diagnostic.set(linter_ns, buf, diagnostics, { severity_sort = true })
        end, function(msg)
          p_handle.message = 'Error: ' .. msg
        end)

        p_handle:finish()
      end
    end)

    uv.read_start(stderr, function(err, data)
      assert(not err, err)
      if data then
        -- print('stderr chunk', stderr, data)
        err_chunks[#err_chunks + 1] = data
      else
        -- local res = table.concat(err_chunks, '')
        -- end of stream
      end
    end)
  end,
}
